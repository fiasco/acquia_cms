#!/bin/sh
# Cloud Hook: Acquia CMS install,update and modules toggle.

which drush
drush --version

site="$1"
target_env="$2"

# Fresh install of Acquia CMS. We need to clear cache first in case memcache is
# enabled, else there will be a collision on site install.
/usr/local/bin/drush9 @$site.$target_env cr

# Only run update hooks on ode4. ode4 is used to test update path.
if [ "$target_env" = "ode4" ]; then
    /usr/local/bin/drush9 @$site.$target_env updatedb --no-interaction
# Install Acquia CMS.
else
    /usr/local/bin/drush9 @$site.$target_env site-install acquia_cms --account-pass=admin --yes --account-mail=no-reply@acquia.com --site-mail=no-reply@acquia.com
fi

/usr/local/bin/drush9 @$site.$target_env pm-enable acquia_cms_development --yes
# Toggle Modules based on the environment.
/usr/local/bin/drush9 @$site.$target_env acms:toggle:modules