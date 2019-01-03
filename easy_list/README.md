# easy_list

A new Flutter application.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.io/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.io/docs/cookbook)

For help getting started with Flutter, view our 
[online documentation](https://flutter.io/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.


### Running Lifecycle

- Running for the first time
`
I/flutter (14370): [ProductManager Widget] Constructor
I/flutter (14370): [ProductManager Widget] createState()
I/flutter (14370): [ProductManager State] initState()
I/flutter (14370): [ProductManager State] build()
I/flutter (14370): [Products Widget] Constructor
I/flutter (14370): [Products Widget] build()
`

- Clicking on Add Product generates the following cycle
`
I/flutter (14370): [ProductManager State] build()
I/flutter (14370): [Products Widget] Constructor
I/flutter (14370): [Products Widget] build()
`