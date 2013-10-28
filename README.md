#### appserv-tomcat Cookbook
=======================
Chef cookbook for configuring a Tomcat application server.

It's very simple. It just installs the tomcat6 package. 

Requirements
------------
Requires Enterprise Linux or Debian distro. Tested on Ubuntu 12.0.4, RHEL 6 and CentOS 6.

Usage
------------

Just include `appserv-tomcat` in the cookbook for your app that needs a Tomcat environment created:

```ruby
include_recipe "appserv-tomcat"
# do any specifics you need in your app recipe hereafter
```

License and Authors
-------------------
Authors: Brian Webb

Copyright 2013 Brian Webb

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

