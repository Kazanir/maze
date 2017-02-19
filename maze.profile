<?php

// Nothing here yet!

function maze_theme_registry_alter(&$registry) {
  $registry['api_class_page']['preprocess functions'][] = 'maze_preprocess_api_class_page';
  $registry['api_class_page__maze'] = $registry['api_class_page'];
  $registry['api_class_page__maze']['path'] = drupal_get_path('profile', 'maze');
  $registry['api_class_page__maze']['base hook'] = 'api_class_page';
  $registry['api_class_page__maze']['template'] = 'maze.api-class-page';

}

function maze_preprocess_api_class_page(&$variables) {
  $variables['theme_hook_suggestion'] = 'api_class_page__maze';

  $variables['code_view'] = &drupal_static('maze_class_page');
}

/**
 * Implements hook_views_api().
 */
function maze_views_api() {
  return array(
    'api' => 3,
    'path' => drupal_get_path('profile', 'maze'),
  );
}

function maze_menu_alter(&$items) {
  $items['api/%api_project/%/class/%api_item']['page callback'] = 'maze_class_page';
}

function maze_class_page($class) {
  $output = &drupal_static(__FUNCTION__);

  $view = views_get_view('api_members');
  $view->override_url = current_path();
  $output = $view->preview('code_list', array($class->did));
  
  return api_page_class($class);
}

function maze_preprocess_views_bootstrap_accordion_plugin_style(&$vars) {
  $view = &$vars['view'];
  $title_field = $vars['options']['title_field'];

  if ($view->name == 'api_members' && $view->current_display == 'code_list') {
    foreach (array_keys($vars['rows']) as $key) {
      $pieces = explode(' ', strip_tags($view->style_plugin->get_field($key, $title_field)));
      $last_word = array_pop($pieces);
      $vars['anchors'][$key] = $last_word;
    }
  }

  $view->style_plugin->saved_anchors = $vars['anchors'];
}

/**
 * Implements hook_advanced_queue_info().
 *
 * On behalf of the API module.
 */
function maze_advanced_queue_info() {
  // Note that the order here is the order the queues will be invoked.
  return array(
    'api_branch_update' => array(
      'worker callback' => '_maze_api_queue_update_branch',
      'weight' => 10,
    ),
    'api_parse' => array(
      'worker callback' => '_maze_api_queue_parse_file',
      'weight' => 20,
    ),
    'api_node_delete' => array(
      'worker callback' => '_maze_api_queue_node_delete',
      'weight' => 30,
    ),
    'maze_api_branch_maintain' => array(
      'worker callback' => '_maze_api_branch_maintain',
      'weight' => -10,
    ),
  );
}

/**
 * Implements hook_cron().
 */
function maze_cron() {
  // Since this is before checking Drupal 8 only for now, let's be generous.
  $top = variable_get('maze_api_top_projects', 300);
  $queue = DrupalQueue::get('maze_api_branch_maintain');

  // Go get a list of the top X projects on Drupal.org.
  $pages = floor(($top - 1) / 100);
  for ($i = 0; $i <= $pages; $i++) {
    $url = 'https://www.drupal.org/api-d7/node.json?type=project_module&sort=field_download_count&direction=DESC&page=' . $i;
    $http = drupal_http_request($url, ['timeout' => 15]);
    if ($http->code != '200') {
      return;
    }

    $response = drupal_json_decode($http->data);
    foreach ($response['list'] as $project_node) {
      $name = $project_node['field_project_machine_name'];
      if ("https://www.drupal.org/project/$name" != $project_node['url']) {
        // Something weird is going on.
        continue;
      }
      // Off, for now.
      // $queue->createItem(['project' => $name, 'nid' => $project_node['nid']]);
    }
  }
}

function _maze_api_queue_update_branch($item) {
  $data = $item->data;
  api_queue_update_branch($data);

  return ADVANCEDQUEUE_STATUS_SUCCESS;
}

function _maze_api_queue_parse_file($item) {
  $data = $item->data;
  api_queue_parse_file($data);

  return ADVANCEDQUEUE_STATUS_SUCCESS;
}

function _maze_api_queue_node_delete($item) {
  $data = $item->data;
  api_queue_node_delete($data);

  return ADVANCEDQUEUE_STATUS_SUCCESS;
}

function _maze_api_branch_maintain($item) {
  $data = $item->data;

  drush_log("Executing maintenance action for project $data[project].");
  // We have a project and it's Drupal.org node ID. Fetch it from the API.
  $url = 'https://www.drupal.org/api-d7/node.json?type=project_release&field_release_project=' . $data['nid'];
  $http = drupal_http_request($url, ['timeout' => 15]);
  if ($http->code != '200') {
    return ADVANCEDQUEUE_STATUS_FAILURE;
  }
  $response = drupal_json_decode($http->data);
  if (!empty($response['list'])) {
    return ADVANCEDQUEUE_STATUS_SUCCESS;
    // @TODO: Check if this release is Drupal 8 compatible and a dev version
    // @TODO: Set up a folder for this project & release
    // @TODO: Update the repository folder of the release/branch if needed
    // @TODO: Set up a project and a branch in the API module
  }
  else {
    return ADVANCEDQUEUE_STATUS_FAILURE;
  }
}

