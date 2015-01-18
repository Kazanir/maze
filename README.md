## Maze

Inspired by [cafuego](https://www.drupal.org/u/cafuego)'s one-time comment about being "lost in a maze of class files", and after some discussion about the relative merits of Backdrop, Drupal 8, and so on with [Damz](https://www.drupal.org/u/damien-tournoud) and [Bojanz](https://www.drupal.org/u/bojanz), I decided to make something that would help me understand the aforementioned mazes of class files more easily.

Maze is a simple install profile for Drupal that pulls together the necessary components to run the [API module](https://drupal.org/project/api) and uses a number of Views hooks and theme trickery to render a new tab on each class page.

By default, this "Code" tab displays every member of the class (whether its own or inherited from a parent or trait) and can be expanded to show the original code of the class. In addition, wherever a `$this->method()` or `$this->property` is detected in the code, those members are linked to the relevant code section on the same page.

Possible todos:

- Make the entire page a single, Gist- or Googlecode-like code display, with the "accordion" feature looking more like the expand/collapse of functions within common IDEs.
- Display the original docblocks of each function, which are sadly not saved in whole form by the API module.
- ??? Feature requests and ideas are welcome.
