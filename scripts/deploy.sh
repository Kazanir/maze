#!/usr/bin/env bash

# Deploy steps
#
# Run this from the Drupal root.

drush -y updatedb
drush cc all
# drush -y fra

