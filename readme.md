# mnygo
* Easy to use and open source **Point of Sale** web-app.
* A simple way to manage your business' sales, clients, providers, products, services, etc.
* It provides a clear interface to view sales reports and analytics about your business.
* Manage your sales online, wherever you are, on any device.

# Built on
Ruby on Rails and MySQL.

# Warning

This project is very old, built on an old and probably insecure version of Rails, and written when I was learning Ruby/Rails, so it probably shouldn't be used in production anywhere and is provided more as a learning tool more than anything else.

I'd love to update it to a modern version of Ruby and Rails, but not sure when I'll get some free time to do so.

# Installation
1) Clone the repository.

2) Install required gems:

    sudo bundle install

3) modify the database info in config/database.yml and do a quick:

    bundle exec rake db:create db:migrate db:seed

That should take care of all tables and initial user (username: admin, password: admin), etc.

4) Done!  You should be able to run:

    bundle exec rails server

Or run it via [pow.cx](http://pow.cx/).

# TO-DO

There's still some work to do, basically polish everywhere, and all the literature (TOS, FAQ, Help, About Us, etc.), but that should be done pretty much on a per-project basis using the included **Page Admin**.

# Screenshots

## Frontpage

![](http://i.imgur.com/4I3CW.png)

---

## Reports dashboard

![](http://i.imgur.com/PUIDI.png)

## Companies

![](http://i.imgur.com/qkKIl.png)

## Company dashboard

![](http://i.imgur.com/Xa61N.png)

---

# Older screenshots

## Product list

![](http://i.imgur.com/avsov.png)

## Plans

![](http://i.imgur.com/rIEV5.png)

## Product details

![](http://i.imgur.com/xGLLp.png)