## Contribute to Feature boxes

Add file or modify the existing files under `pages/`. Make sure to add
`type: feature` in page metadata to get listed in Showcase boxes in
home page.

Example:

```markdown
---
type: feature
title: Hello World
---

Hello World!
```

## Contribute to About page

Update the `pages/about.md` with required changes.

## Add new Blog post

Create new file in `_posts/` directory. Name of the file should be in
`<Year>-<Month>-<Date>-<url>.md`. For example,
`2019-01-01-my-gcs-blog.md`. When site is built, this URL will
become blog URL. For example,
`http://gluster.github.com/glustercs/blog/my-gcs-blog`

Following metadata are required to publish as blog,

```markdown
---
title: My GCS blog
layout: post
author: Aravinda VK
---

Blog Content
```

Always use relative URL for images or any other include. For example,
to include a image(`gcs-setup.jpg`) in the blog, copy the image to
`images/` directory then use `![Alt Text](../images/gcs-setup.jpg)`

## Contribute to the Documentation

Update the file `doc/*.md` with required changes. Make sure to add `layout: doc` and order in metadata. For example,

```markdown
---
title: Monitoring
layout: doc
order: 6
---

Content
```

## Testing the Website locally

- Clone this repo and checkout `gh-pages` branch.
- Install `ruby-devel` package(`sudo dnf install ruby-devel`)
- Install `jekyll` using `sudo gem install bundler jekyll`
- Install the dependencies from project directory `bundle install
  --path vendor/bundle`
- From this project directory, run `bundle exec jekyll serve --baseurl=""`
