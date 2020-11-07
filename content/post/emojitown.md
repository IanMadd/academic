---
# Documentation: https://sourcethemes.com/academic/docs/managing-content/

title: "Emojitown"
subtitle: ""
summary: ""
authors: []
tags: []
categories: []
date: 2020-10-16T16:46:14-07:00
lastmod: 2020-10-16T16:46:14-07:00
featured: false
draft: false

# Featured image
# To use, add an image named `featured.jpg/png` to your page's folder.
# Focal points: Smart, Center, TopLeft, Top, TopRight, Left, Right, BottomLeft, Bottom, BottomRight.
image:
  caption: ""
  focal_point: ""
  preview_only: false

# Projects (optional).
#   Associate this post with one or more of your projects.
#   Simply enter your project's folder or file name without extension.
#   E.g. `projects = ["internal-project"]` references `content/project/deep-learning/index.md`.
#   Otherwise, set `projects = []`.
projects: []
---

Do you ever think to yourself, blogs just aren't any fun anymore. I mean sure, there's the :poop: emoji. You could add that to blog post. That's fun. But then you see the :poop: emoji a few times, and they make a movie about it and the reviewers say that the movie is ["so completely devoid of wit, style, intelligence or basic entertainment value that it makes that movie based on the Angry Birds app seem like a pure artistic statement by comparison"](https://www.rogerebert.com/reviews/the-emoji-movie-2017), and then you're like, "Wow, I am bored."

If you're bored like that and you have a Hugo blog, you can add any of about 2,500 custom emoji to your site by using the [Emojitown Hugo module](https://github.com/IanMadd/emojitown).

To add Emojitown to your site, add the following to your site's config file:

```toml
[module]
  [[module.imports]]
    path = "github.com/ianmadd/emojitown"
  [[module.imports.mounts]]
    source = "data"
    target = "data"
  [[module.imports.mounts]]
    source = "layouts/shortcodes"
    target = "layouts/shortcodes"
  [[module.imports.mounts]]
    source = "static"
    target = "static"
```

The run `hugo mod get github.com/ianmadd/emojitown` to add the module to your site.
From there you use Emojitown to add all kinds of custom emoji to your Hugo site.

Do you want spice up your blog by adding a dancing MC Hammer? Just add `{{</* emojitown emoji="mchammer" */>}}` to your blog page and you've got MC Hammer dancing all day {{< emojitown emoji="mchammer" >}}. Do you want a dancing Chewbacca {{< emojitown emoji="chewbacca" >}}, dancing Ned Flanders {{< emojitown emoji="diddlydoo" >}}, or a birb at a rave {{< emojitown emoji="birbrave" >}}? Done.

**But wait, there's more!**

What if one emoji just doesn't fully express what you feel about something? Maybe an old man shaking his fist at the clouds {{< emojitown emoji="shakesfist" >}} just isn't strong enough to express how much you dislike something. For those special cases, the emojitown shortcode has the `emojiparty` parameter. If you really don't like something, just drop a barf party on it like this, `{{</* emojitown emojiparty="barf" */>}}` and tell the world how you really feel.

{{< emojitown emojiparty="barf" >}}

The emojitown shortcode looks through the JSON file for every emoji name that partially matches the `emojiparty` parameter, and then it displays every matching file. That means that `emojiparty="barf"` gets you `sigh-barfing.png`, `barfing-santa.png`, `clown-barf.png`, and every other file that returns a match from the JSON file.

Want to have a dance party? Just add `emojiparty="dance"` to emojitown:

{{< emojitown emojiparty="dance" >}}

Do you want a parrot wave? We've got that.

{{< emojitown emojiparty="parrotwave" >}}

Whether you did something stupid {{< emojitown emoji="doh" >}}, think something is great
{{< emojitown emoji="awesome" >}}, are mildly irritated {{< emojitown emoji="sigh" >}},
or are dealing with a disaster {{< emojitown emoji="dumpster_fire" >}}, emojitown has
you covered.

With that, I leave you with the emojiparty party.

{{< emojitown emojiparty="party" >}}
