<?php

/**
 * Implements hook_views_data_alter().
 */
function maze_views_data_alter(&$data) {
  $ad = &$data['api_documentation'];
  $ad['code'] = array(
    'title' => t('Code'),
    'help' => t('The code of this documentation item.'),
    'field' => array(
      'handler' => 'views_handler_field_markup',
      'format' => 'full_html',
    ),
  );

  $ad['documentation'] = array(
    'title' => t('Documentation'),
    'help' => t('The HTML documentation of this item.'),
    'field' => array(
      'handler' => 'views_handler_field_markup',
      'format' => 'full_html',
    ),
  );


}

function maze_views_default_views_alter(&$views) {
  $view = &$views['api_members'];
  /* Display: Code List */
  $handler = $view->new_display('block', 'Code List', 'code_list');
  $handler->display->display_options['defaults']['style_plugin'] = FALSE;
  $handler->display->display_options['style_plugin'] = 'views_bootstrap_accordion_plugin_style';
  $handler->display->display_options['style_options']['title_field'] = 'title';
  $handler->display->display_options['defaults']['style_options'] = FALSE;
  $handler->display->display_options['defaults']['row_plugin'] = FALSE;
  $handler->display->display_options['row_plugin'] = 'fields';
  $handler->display->display_options['defaults']['row_options'] = FALSE;
  $handler->display->display_options['defaults']['fields'] = FALSE;
  /* Field: API documentation: Title */
  $handler->display->display_options['fields']['title']['id'] = 'title';
  $handler->display->display_options['fields']['title']['table'] = 'api_documentation';
  $handler->display->display_options['fields']['title']['field'] = 'title';
  $handler->display->display_options['fields']['title']['relationship'] = 'did';
  $handler->display->display_options['fields']['title']['label'] = '';
  $handler->display->display_options['fields']['title']['element_label_colon'] = FALSE;
  $handler->display->display_options['fields']['title']['link_to_docs'] = 'object';
  /* Field: API documentation: Documentation */
  $handler->display->display_options['fields']['documentation']['id'] = 'documentation';
  $handler->display->display_options['fields']['documentation']['table'] = 'api_documentation';
  $handler->display->display_options['fields']['documentation']['field'] = 'documentation';
  $handler->display->display_options['fields']['documentation']['relationship'] = 'did';
  $handler->display->display_options['fields']['documentation']['label'] = '';
  $handler->display->display_options['fields']['documentation']['element_label_colon'] = FALSE;
  /* Field: API documentation: Code */
  $handler->display->display_options['fields']['code']['id'] = 'code';
  $handler->display->display_options['fields']['code']['table'] = 'api_documentation';
  $handler->display->display_options['fields']['code']['field'] = 'code';
  $handler->display->display_options['fields']['code']['relationship'] = 'did';
  $handler->display->display_options['fields']['code']['label'] = '';
  $handler->display->display_options['fields']['code']['element_label_colon'] = FALSE;
  $handler->display->display_options['defaults']['sorts'] = FALSE;
  /* Field: API documentation: Modifiers */
  $handler->display->display_options['fields']['modifiers']['id'] = 'modifiers';
  $handler->display->display_options['fields']['modifiers']['table'] = 'api_documentation';
  $handler->display->display_options['fields']['modifiers']['field'] = 'modifiers';
  $handler->display->display_options['fields']['modifiers']['relationship'] = 'did';
  $handler->display->display_options['fields']['modifiers']['label'] = '';
  $handler->display->display_options['fields']['modifiers']['exclude'] = TRUE;
  $handler->display->display_options['fields']['modifiers']['alter']['alter_text'] = TRUE;
  $handler->display->display_options['fields']['modifiers']['alter']['text'] = '[modifiers] [title]';
  $handler->display->display_options['fields']['modifiers']['element_label_colon'] = FALSE;
  $handler->display->display_options['defaults']['sorts'] = FALSE;
  /* Sort criterion: API documentation: Object type */
  $handler->display->display_options['sorts']['object_type']['id'] = 'object_type';
  $handler->display->display_options['sorts']['object_type']['table'] = 'api_documentation';
  $handler->display->display_options['sorts']['object_type']['field'] = 'object_type';
  $handler->display->display_options['sorts']['object_type']['relationship'] = 'did';
  $handler->display->display_options['sorts']['object_type']['order'] = 'DESC';
  /* Sort criterion: API documentation: Member name */
  $handler->display->display_options['sorts']['member_name']['id'] = 'member_name';
  $handler->display->display_options['sorts']['member_name']['table'] = 'api_documentation';
  $handler->display->display_options['sorts']['member_name']['field'] = 'member_name';
  $handler->display->display_options['sorts']['member_name']['relationship'] = 'did';
  $handler->display->display_options['defaults']['filter_groups'] = FALSE;
  $handler->display->display_options['defaults']['filters'] = FALSE;

}

function maze_views_pre_render(&$view) {
  if ($view->name == 'api_members' && $view->current_display == 'code_list') {
    foreach ($view->result as $res) {
      $res->api_documentation_api_members_modifiers = str_pad($res->api_documentation_api_members_modifiers, 18);
      $split = explode("::", $res->api_documentation_api_members_title);
      $cn = str_pad($split[0], 35);
      $res->api_documentation_api_members_title = $cn . $split[1];
    }
  }
}

function maze_views_post_render(&$view, &$output, $cache) {
  if ($view->name == 'api_members' && $view->current_display == 'code_list') {
    // Get our anchors from the results of our preprocess function; we need them to find the accordion ID.
    $anchors = array_flip($view->style_plugin->saved_anchors);

    $output = preg_replace_callback('%(function|property) member-of-self\">(\w+)</span>%i', function($matches) use ($anchors) {
      $prefix = ($matches[1] == 'property' ? '$' : '');
      $return = $matches[1];
      $return .= ' member-of-self"><a href="#code--this::';
      $return .= $prefix;
      $return .= $matches[2];
      $return .= '" class="accordion-toggle" data-toggle="collapse" data-target="#collapse-1-';
      $return .= (isset($anchors[$prefix . $matches[2]]) ? $anchors[$prefix . $matches[2]] : $anchors[$matches[2]]);
      $return .= '">' . $matches[2] . '</a></span>';

      return $return;
    }, $output);
    //
  }
}

