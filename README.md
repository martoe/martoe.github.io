[![Build Status](https://travis-ci.org/martoe/martoe.github.io.png)](https://travis-ci.org/martoe/martoe.github.io/)

[Main site](http://blog.ehrnhoefer.com/)

## Getting started on Windows

1. Download Jekyll:

        git clone git@github.com:madhur/PortableJekyll.git
        git clone git@github.com:martoe/martoe.github.io.git

1. Prepare Jekyll (as of Feb 2016, GitHub Pages uses Jekyll 3.0):

        cd PortableJekyll
        git checkout 3.0.0
        setpath.cmd
        cd ..\martoe.github.io
        gem install bundler
        bundle install
        bundle update

1. Start Jekyll (as of Feb 2016, GitHub Pages uses Jekyll 3.0):

        cd PortableJekyll
        setpath.cmd
        cd ..\martoe.github.io
        jekyll serve --drafts

1. Open [localhost:4000](http://localhost:4000/)

## Links

* [Jekyll Docs](http://jekyllrb.com/docs/posts/)
* [Highlight Lexers](http://pygments.org/docs/lexers/)
* [Comments with Disqus](https://help.disqus.com/customer/portal/articles/472138-jekyll-installation-instructions)
* [Import from Blogger](http://import.jekyllrb.com/docs/blogger/)
* [Static tags](http://www.minddust.com/post/tags-and-categories-on-github-pages/)
