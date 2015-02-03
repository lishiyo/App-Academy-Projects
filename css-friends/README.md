# CSS Friends

We're going to build a social network for App Academy! A mock-up, that is.

Often when working as a front-end developer you'll be collaborating with a designer. Most likely they will provide you with a sequence of screenshots and specifications for you to convert into neatly, maintainable HTML and CSS.

Check out today's [end goal][live-12]. With some clear [specifications][specs], a bunch of [screenshots][shots], and some hints broken down in 12 phases, you will make a pixel perfect replica in code in no time.

## A Few Thoughts Before You Start...

- Make sure to keep the [specs][specs] at your side at all time.
- Open the [screenshots][shots] in Apple's Preview to study them. You get a nice crosshair to select and measure elements. You can also zoom.
- Use Chrome and the inspector tools. Make sure not to accidentally be zoomed in on your page. The screenshots and browser ratio should be 1:1.
- You will be writing your HTML in the `friends.html` file in the skeleton folder.
- Each phase corresponds to a numbered CSS file you should use.
- Always use [semantic tags][tags] when writing HTML. Avoid using `<div>` and `<span>` tags, they should only be used as a last resort and are frowned upon.
- Indent and space out your HTML cleanly. That is the only way to maintainable code.
- Always [validate][valid] your HTML. It's easy for subtle layout bugs to creep in because of invalidly nested or unclosed tags.
- Double quote your attributes: `<nav class="header-nav">`.
- Use descriptive classes. Convention is to make them all lowercase, using dashes. I like to use dashes to note nesting. I may have a parent `.header` element, with children named `.header-nav` and a `.header-list`.
- Keep your selectors shallow. Nesting increases [specificity][specificity], which in turn increases precedence. Use this [calculator][calculator] to untangle.
- Never use [IDs][ids-boo] as selectors
- Finally, enjoy the beauty in the details. A designer's favorite game is Spot The Difference. So-so approximations never suffice, and they will kindly let you know.
- You can do it!

[specs]: ./SPECIFICATIONS.md
[shots]: ./screenshots
[specificity]: http://cssguidelin.es/#specificity
[ids-boo]: http://csswizardry.com/2014/07/hacks-for-dealing-with-specificity/
[calculator]: http://specificity.keegan.st/
[valid]: http://validator.w3.org/
[tags]: https://developer.mozilla.org/en-US/docs/Web/Guide/HTML/HTML5/HTML5_element_list


## Phase 0: Reset

**Topics:** [Reset][t-reset], [Appearance][t-appearance], [Clearfix][t-clearfix], [Box-model][t-box-model], [Box-sizing][t-box-sizing], [Cursor][t-cursor]

- [Screenshot A][ss-00-a]
- [Live][live-00]

Let's start with a clean slate, by writing a reset in `./css/00-reset.css`. To speed you up, we provided some tag selectors to get you started. Be wise about which properties to inherit, and which to hard-code. Besides the regular, I'd like you to set the `box-sizing` property to inherit, to have all elements behave the same, which is content-box, by default.

Let's make all images `block` elements, have them expand to the full `100%` width of their parent container, and have their height grow `auto`, which means proportionally.

Remove the bullets from list items, strip the browser chrome from form input elements by setting its appearance to none, and show the little pointer hand on buttons to make it obvious you can click. Finally include the clearfix in your code. We'll be using it a lot!

[ss-00-a]: ./screenshots/00-reset-a.png
[live-00]: http://appacademy.github.io/css-friends/solution/00-reset.html

[t-reset]: https://github.com/appacademy/css-demos/#user-agent-styles
[t-appearance]: http://css-tricks.com/almanac/properties/a/appearance/
[t-clearfix]: https://github.com/appacademy/css-demos/#clearfix
[t-box-model]: https://github.com/appacademy/css-demos/#box-model
[t-box-sizing]: http://appacademy.github.io/css-demos/box-sizing.html
[t-cursor]: https://developer.mozilla.org/en-US/docs/Web/CSS/cursor


## Phase 1: Header

**Topics:** [Webfonts][t-webfonts], [Font-weight][t-font-weight], [Block][t-block], [Float][t-float], [Clearfix][t-clearfix], [Border][t-border]

- [Screenshot A][ss-01-a]
- [Screenshot B][ss-01-b]
- [Live][live-01]

Let's study the first *real* set of screenshots and make a plan of attack.

Typography is always the best place to start. Pull up the specs. The first thing you'll notice is a font family that most computers do not have installed. Fortunately, Google provides it to us for free as a hosted webfont. Find it on [Google Fonts][t-google-fonts], select the appropriate font-weights, and include the provided `<link>` tag right before the other `<link>` tags in the `<head>`.

In `./css/01-header.css` set the default font weight, family and size on the `body` tag. If you set up your reset correctly, these styles will nicely trickle down to all child elements going forward.

The next step is to analyze the screenshots. You want to start thinking of everything as being contained in boxes. We see an outer red box that expands to the full width, with inside it a fixed width box. On the left you see the "App Academy Friends" logo heading, and on the right a list of links. Think about how you can express these meanings using semantic tags. First write your HTML, then lay out your CSS selectors. Remember to use classes to label things appropriately.

To center a smaller block element inside a larger block element, you'll want to set its left and right margins to `auto`. Since block elements cannot sit next to each other normally, you're going to need floats. Whenever you float, you will need to clearfix. It's OK to float things inside of floated things.

As you'll be adding dummy links throughout this project, I recommend using a pound sign as the href: `<a href="#">`. That will prevent a page reload.

It can be helpful to give elements a temporary background color, to see their appearance while debugging.

As you put paddings in place, remember that usability is important. We want large click targets. Also do not forget the hover states, this is important and gratifying feedback for the user.

Pixel perfect? Do not move on before calling over a **TA** to check your work!

[ss-01-a]: ./screenshots/01-header-a.png
[ss-01-b]: ./screenshots/01-header-b.png
[live-01]: http://appacademy.github.io/css-friends/solution/01-header.html

[t-webfonts]: http://en.wikipedia.org/wiki/Web_typography
[t-google-fonts]: https://www.google.com/fonts
[t-font-weight]: http://css-tricks.com/almanac/properties/f/font-weight/
[t-block]: https://github.com/appacademy/css-demos/#display-block
[t-float]: https://github.com/appacademy/css-demos/#floats
[t-border]: http://css-tricks.com/almanac/properties/b/border/


## Phase 2: Notifications

**Topics:** [Border-radius][t-border-radius], [Positioning][t-positioning], [Overflow][t-overflow], [Display][t-display], [White-space][t-white-space], [Z-index][t-z-index]

- [Screenshot A][ss-02-a]
- [Screenshot B][ss-02-b]
- [Screenshot C][ss-02-c]
- [Live][live-02]

We're adding notifications! Add an inline badge, inside the notifications `<a>` tag. Give it the reusable `.badge` class and style it round as a circle. You'll want to tweak the padding to get it just right.

For the dropdown, start by nesting a new list of notification list elements inside of the original notification list element. Add it right below the `<a>` tag. You'll see how it stretches the whole header bar down. It sort of looks right, if only we could lift it out of the document flow, and have it not stretch its parent. Aha, you say! Positioning! Remember to create a coordinate system you control, by setting its parent to `relative` position.

The trick to hiding and showing the dropdown is combining the `:hover` selector and the display property. How would you select the dropdown when someone hovers over the parent notification list item?

If you'd like a hint at this point, check out this amazing [cat with glasses][t-glasses-demo] demo.

To keep the notification text on one line you may use the `white-space` property.

As you add borders to everything, make sure to nudge the dropdown to line up nicely with vertical lines in the navigation bar. Finally, you may have issues with a list item poking through the bottom rounded edges. Fix this using the overflow property.

Before moving on to Phase 3, add a `z-index` of `1` to the whole header bar. In order to do this, you will also have to set the `position` property to `relative`. This should not change anything visually as-is, but will ensure that our header dropdown will stay on top as we move on and add more to the page.

Pat yourself on the back, you've earned it! By now we've covered the core concepts of CSS. Things will just get easier and *way* more fun!

[ss-02-a]: ./screenshots/02-notifications-a.png
[ss-02-b]: ./screenshots/02-notifications-b.png
[ss-02-c]: ./screenshots/02-notifications-c.png
[live-02]: http://appacademy.github.io/css-friends/solution/02-notifications.html

[t-border-radius]: https://developer.mozilla.org/en-US/docs/Web/CSS/border-radius
[t-positioning]: https://github.com/appacademy/css-demos/#positioning
[t-overflow]: https://developer.mozilla.org/en-US/docs/Web/CSS/overflow
[t-display]: https://github.com/appacademy/css-demos/#the-display-property
[t-white-space]: https://developer.mozilla.org/en-US/docs/Web/CSS/white-space
[t-z-index]: https://github.com/appacademy/css-demos/#z-index
[t-glasses-demo]: http://appacademy.github.io/css-demos/positioning.html


## Phase 3: Layout

**Topics:** [Float][t-float], [Clearfix][t-clearfix], [Pseudo-content][t-pseudo-content], [Positioning][t-positioning]

- [Screenshot A][ss-03-a]
- [Live][live-03]

Make a `.content` container, with a sidebar section and a main section in it. Give them widths and paddings and float them next to each other. As they do not have content yet, set a `min-height` property to `200px` to ensure they have some height, even when empty. Set temporary background colors on the elements to verify that they are properly next to each other and the correct size.

Since there might be cases where either the sidebar or the main container could be longer, we cannot simply add a border to one of their sides to create the divider line in the middle. We want the line always to be the full height of parent `.content` container. We're going to flex our CSS muscles and combine pseudo-content with absolute positioning to accomplish this.

Use `:before` pseudo-content to inject an element inside the `.content` container. Make it a `block` element and `position` it `absolute`. Give it a `width` of `1px`, set the `left` coordinate appropriately, but set the `top` and `bottom` simultaneously to `0`. This will nicely stretch out the element to the top and bottom. Don't forget the gray background color. Voila!

[ss-03-a]: ./screenshots/03-layout-a.png
[live-03]: http://appacademy.github.io/css-friends/solution/03-layout.html

[t-pseudo-content]: https://github.com/appacademy/css-demos/#pseudo-content


## Phase 4: Footer

**Topics:** [Float][t-float], [Clearfix][t-clearfix], [Border-radius][t-border-radius]

- [Screenshot A][ss-04-a]
- [Screenshot B][ss-04-b]
- [Live][live-04]

Add the footer to the bottom of the document. It does not need to be nested. You should be getting the hang of this by now! Floats in floats. Pay close attention to colors and typography.

[ss-04-a]: ./screenshots/04-footer-a.png
[ss-04-b]: ./screenshots/04-footer-b.png
[live-04]: http://appacademy.github.io/css-friends/solution/04-footer.html


## Phase 5: Cats

**Topics:** [Background-size][t-background-size], [Positioning][t-positioning], [Text-shadow][t-text-shadow]

- [Screenshot A][ss-05-a]
- [Screenshot B][ss-05-b]
- [Live][live-05]

Create a `.content-header` section and put it in top of the `.content` container, above the sidebar and main section. Give it a height and use the supplied `./shared/img/cats.jpg` image as a background. Make sure the background image covers the full section.

Add a heading and button and position them absolute at the bottom. To keep the heading legible on a varied background, use the `text-shadow` property to increase contrast.

[ss-05-a]: ./screenshots/05-cats-a.png
[ss-05-b]: ./screenshots/05-cats-b.png
[live-05]: http://appacademy.github.io/css-friends/solution/05-cats.html

[t-background-size]: https://developer.mozilla.org/en-US/docs/Web/CSS/background-size
[t-text-shadow]: https://developer.mozilla.org/en-US/docs/Web/CSS/text-shadow


## Phase 6: Sidebar

**Topics:** [Positioning][t-positioning], [Pseudo-selectors][t-pseudo-selectors]

- [Screenshot A][ss-06-a]
- [Screenshot B][ss-06-b]
- [Live][live-06]

Divide the sidebar up into three sections: `.profile-picture`, `.profile-info`, and `.profile-nav`.

Have the `.profile-picture` be a link that contains an image tag with the provided `./shared/img/cat.jpg` picture. Make the link a `block` element and style it. Thanks to your earlier reset, the image will now expand to fill the full width of the link.

To pull the `.profile-picture` partly out of its sidebar section, use a negative top margin. To make sure it is in front of the `.content-header` section, you will have to position it `relative`. You do not need to nudge it or give it a z-index. As they're now both `relative`, order of appearance on the page dictates the stacking order. This is in our favor, as `.profile-picture` is declared later.

To get the divider lines between all the `.profile-nav` list elements, but also at the top and bottom, you'll want to use a pseudo selector like `:first-child`, `:last-child`, or `:nth-child()`.

[ss-06-a]: ./screenshots/06-sidebar-a.png
[ss-06-b]: ./screenshots/06-sidebar-b.png
[live-06]: http://appacademy.github.io/css-friends/solution/06-sidebar.html

[t-pseudo-selectors]: http://css-tricks.com/pseudo-class-selectors/


## Phase 7: Online

**Topics:** [Positioning][t-positioning], [Overflow][t-overflow], [Transform][t-transform], [Letter-spacing][t-letter-spacing], [Text-transform][t-text-transform], [Box-shadow][t-box-shadow]

- [Screenshot A][ss-07-a]
- [Live][live-07]

Celebrate being online with a a nice ribbon! Put an `.online` element inside of the `.profile-picture` link. Position it absolute to be on top of the image. Then go bonkers styling it using fancy `transform` properties like `rotate()` and `translateX()`. Pay attention to typography and don't forget to add a tiny `box-shadow`.

[ss-07-a]: ./screenshots/07-online-a.png
[live-07]: http://appacademy.github.io/css-friends/solution/07-online.html

[t-transform]: https://developer.mozilla.org/en-US/docs/Web/CSS/transform
[t-letter-spacing]: https://developer.mozilla.org/en-US/docs/Web/CSS/letter-spacing
[t-text-transform]: https://developer.mozilla.org/en-US/docs/Web/CSS/text-transform
[t-box-shadow]: https://developer.mozilla.org/en-US/docs/Web/CSS/box-shadow


## Phase 8: Thumbs

**Topics:** [Float][t-float], [Clearfix][t-clearfix], [Border-radius][t-border-radius], [Pseudo-content][t-pseudo-content], [Positioning][t-positioning], [Transform][t-transform]

- [Screenshot A][ss-08-a]
- [Screenshot B][ss-08-b]
- [Live][live-08]

A grid of friends! Use a list and float them all ! Spacing them out properly will be tricky. You will need to use `:nth-child()` psuedo-selectors to add some margin.

Create a `.thumb` class to style the links that contain the thumbnails. You can use the same `./shared/img/cat.jpg` picture for the image tag. We will want to reuse this `.thumb` class later.

Add `title` attributes containing friend names to the link tags. You should have something like: `<a href="#" class="thumb" title="Jonathan">`. Then use `:before` pseudo-content to grab this title and inject it into the link. Style this, make it a `block` element and position it absolute.

To position an `absolute` element in the center relative to its parent, use a combination of `left: 50%` and `transform: translateX(-50%)`. The `left` percentage is relative to its parent, and will set the current element's left most pixel to half its parent width. Since this is too far to the left, we have to adjust this by subtracting half our own width. The `translateX()` value takes a percentage relative to itself, which is exactly what we need.

[ss-08-a]: ./screenshots/08-thumbs-a.png
[ss-08-b]: ./screenshots/08-thumbs-b.png
[live-08]: http://appacademy.github.io/css-friends/solution/08-thumbs.html


## Phase 9: Forms

**Topics:** [Float][t-float], [Clearfix][t-clearfix], [Border-radius][t-border-radius], [Pseudo-selectors][t-pseudo-selectors], [Box-shadow][t-box-shadow], [Border-radius][t-border-radius]

- [Screenshot A][ss-09-a]
- [Screenshot B][ss-09-b]
- [Screenshot C][ss-09-c]
- [Screenshot D][ss-09-d]
- [Live][live-09]

Reuse your `.thumb` class. Float the thumbnail and the form next to each other. Wrap your inputs and labels in container elements with an `.input` class. Wrap the button in a `.submit` container. Style them so you can reuse them. Pay special attention to the `:focus` and ':active' pseudo-classes.

[ss-09-a]: ./screenshots/09-forms-a.png
[ss-09-b]: ./screenshots/09-forms-b.png
[ss-09-c]: ./screenshots/09-forms-c.png
[ss-09-d]: ./screenshots/09-forms-d.png
[live-09]: http://appacademy.github.io/css-friends/solution/09-forms.html


## Phase 10: Posts

**Topics:** [Float][t-float], [Clearfix][t-clearfix], [Pseudo-content][t-pseudo-content]

- [Screenshot A][ss-10-a]
- [Live][live-10]

Crush this using semantic tags and your floating skills. How about using pseudo-content to inject little dots `·` in between the list items?

[ss-10-a]: ./screenshots/10-posts-a.png
[live-10]: http://appacademy.github.io/css-friends/solution/10-posts.html


## Phase 11: Icons

**Topics:** [Pseudo-selectors][t-pseudo-selectors], [Background-size][t-background-size], [Background-position][t-background-position], [Overflow][t-overflow]

- [Screenshot A][ss-11-a]
- [Screenshot B][ss-11-b]
- [Live][live-11]

Use the supplied `./shared/img/sprite.png` image, as well as the coordinates in the spec, to create a bunch of icon classes, such as `.icon-favorite` and `.icon-comment`. You can select all of the classes using the `[class*="icon-"]` pseudo-selector. Set the background image to the sprite only once, then for each individual class set only the background coordinates.

[ss-11-a]: ./screenshots/11-icons-a.png
[ss-11-b]: ./screenshots/11-icons-b.png
[live-11]: http://appacademy.github.io/css-friends/solution/11-icons.html

[t-background-position]: https://developer.mozilla.org/en-US/docs/Web/CSS/background-position


## Phase 12: Modal

**Topics:** [Positioning][t-positioning], [Border-radius][t-border-radius]

- [Screenshot A][ss-12-a]
- [Screenshot B][ss-12-b]
- [Screenshot C][ss-12-c]
- [Live][live-12]

Create a `.modal` container at the bottom of the page, with `<body>` as its parent. Have it contain two sections: `.modal-screen` and `.modal-form`.

Give `.modal-screen` a `fixed` position. By setting `top`, `bottom`, `left`, `right` all to `0`, we will stretch it out to fill the entire screen. Add a `z-index` of `2` to have it sit in front of everything else on the page. Give it a `rgba(0,0,0,0.8)` value for its `background` property. The `0.8` alpha will make it slightly see-through.

Position the `.modal-form` absolute, using the centering trick from earlier. Style it reusing the `.input` and `.submit` classes you created.

You may want to use the `&times;` HTML-entity as your `x` closing button.

Toggle the showing and hiding of the modal based on the presence of the `.is-open` class on the `.modal` parent container. Use the display property.

Use the following script to make the toggling work in your mockup. Add the classes `.js-modal-open` and `.js-modal-close` to any elements you want to add interactivity. Enjoy!

```html
<script src="../shared/js/jquery.js"></script>
<script>
$(function(){

  $("body").on("click", ".js-modal-open", function(event){
    event.preventDefault();
    $(".modal").addClass("is-open");
  });

  $("body").on("click", ".js-modal-close", function(event){
    event.preventDefault();
    $(".modal").removeClass("is-open");
  });

});
</script>
```

[ss-12-a]: ./screenshots/12-modal-a.png
[ss-12-b]: ./screenshots/12-modal-b.png
[ss-12-c]: ./screenshots/12-modal-c.png
[live-12]: http://appacademy.github.io/css-friends/solution/12-modal.html
