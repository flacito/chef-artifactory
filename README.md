#### Artifactory Cookbook
=======================
Chef cookbook for configuring a JFrog Artifactory application server.

Allows you to configure a standalone Artifactory server or an HA cluster (HA requires an external DB and an NFS share). Cookbook supports either RPM install or manual ZIP file install.

Take a look at the default attributes. There are several overrides you will need to make to successfully converge in your environmnent. Examples: where is your RPM or ZIP archive for the Artifactory binary? where is your JDBC driver if you're going to do an external DB or HA? 

There are a few knobs at the top of [the attributes](https://github.com/flacito/chef-artifactory/blob/master/attributes/default.rb) that let you flip the install behavior. These should be self evident. 

See Usage below for more details.

**Todo:** 

* Chefspec (Berkshelf stuff too)
* Test Kitchen
 

Requirements
------------
Requires Enterprise Linux or Debian distro. Tested on CentOS 7.

Requires JDK 1.7 or higher.

Usage
------------
Just change the attributes to meet your needs and bootstrap with the artifactory::default recipe, or add the artifactory::default recipe to a role or run list.

If you want an external DB or HA, then data_bags/artifactory/db.json
> {
>   "id":"db",
>   "db_host":"your host fqdn",
>   "db_name":"artifactory db",
>   "db_user":"artifactory db user",
>   "db_password":"artifactory db password"
> }

If you want HA, then data_bags/artifactory/nfs.json
> {
>   "id":"nfs",
>   "nfs_host":"172.16.18.203",
>   "nfs_directory":"/var/nfs/artifactory"
> }

Finally, there's a files/default/config.zip file there for you if you want to import an existing configueration of Artifactory. The one in the recipe just adds Ruby gems and Restlet as remote repos. See the Artifactory documentation on exporting a configuration. Doing so as an archive and no artifacts is recommended; otherwise, you'll have a _huge_ config.zip file to store in the cookbook and that's no good.

License and Authors
-------------------
Authors: Brian Webb

Copyright 2014 Brian Webb

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

