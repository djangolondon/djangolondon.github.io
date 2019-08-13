# The London Django Meetup Group

The official Github repo of The London Django Meetup Group.

View the site at
[http://www.djangolondon.com](http://www.djangolondon.com).

## Contribution

Please share by sending through a Pull Request. All constructive contributions
are very welcome. Please let us know if we've made a mistake or an omission by
opening an Issue.


## Running the site locally

This site is built with Jekyll and hosted on Github Pages. They have [an
excellent guide for testing the site locally]
(https://help.github.com/articles/setting-up-your-github-pages-site-locally-with-jekyll/)
that should get you set up.

## Quickly fire up project with Docker

Make sure you've got the latest version of Docker and docker-compose.

Just run `docker-compose up -d` to get started.

The app will be served at `http://127.0.0.1:4000/`, the slides for the meetup will be at `/organizers/2018-06-25/`.

## Auto-build on save and live-reload

Jekyll can build the site static files automatically as the source files are updated. To run Jekyll in auto-building mode run `guard -i`, alternatively just run `jekyll serve`.

The Docker instance runs with auto-build enabled by default.

If you want to manually build the project run `jekyll build` or if using Docker `docker-compose run app jekyll build`

Live-reload is supported in this project, this means that, as the project is updated, you don't have to constantly refresh the browser window.

To enable live-reloading in your browser [install the appropriate extension for your browser](http://livereload.com/extensions/#installing-sections)
