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
  $items['api/%/%/class/%api_item']['page callback'] = 'maze_class_page';
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

