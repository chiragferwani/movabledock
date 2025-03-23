import 'package:flutter/material.dart';

///main method
void main() {
  runApp(const MyApp());
}

///widget for the app
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, //remove the banner
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center, //centre dock vertically
          children: [
            Dock(
              items: const [      //array for icons
                Icons.person,
                Icons.message,
                Icons.call,
                Icons.camera,
                Icons.photo,
              ],
              builder: (e) {  //create container for each icon
                return Container(
                  constraints: const BoxConstraints(minWidth: 48),
                  height: 64,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      e,  //passing the icon data
                      color: [
                        Colors.blue,
                        Colors.red,
                        Colors.green,
                        Colors.orange,
                        Colors.purple
                      ][e.hashCode % 5], //assign different colors
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Dock of the reorderable [items].
class Dock<T> extends StatefulWidget {
  const Dock({
    super.key,
    this.items = const [],
    required this.builder,
  });

  /// Initial [T] items to put in this [Dock].
  final List<T> items;

  /// Builder building the provided [T] item.
  final Widget Function(T) builder;

  @override
  State<Dock<T>> createState() => _DockState<T>();
}

/// State of the [Dock] used to manipulate the [_items].
class _DockState<T> extends State<Dock<T>> {
  /// [T] items being manipulated.
  late final List<T> _items = widget.items.toList();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center, // Ensures the dock is centered horizontally
      child: Container(
        
        decoration: BoxDecoration(
          
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey[200],
        ),
        padding: const EdgeInsets.symmetric(vertical: 8),
        height: 100,
        width: MediaQuery.of(context).size.width * 0.83, // Keeps dock width within screen
        child: ReorderableListView(
          scrollDirection: Axis.horizontal,
          buildDefaultDragHandles: false,
          onReorder: (oldIndex, newIndex) {
            setState(() {
              if (newIndex > oldIndex) {
                newIndex -= 1;
              }
              final item = _items.removeAt(oldIndex);
              _items.insert(newIndex, item);
            });
          },
          children: <Widget>[
            for (int index = 0; index < _items.length; index++)
              ReorderableDragStartListener(
                key: ValueKey(_items[index]),
                index: index,
                child: widget.builder(_items[index]),
              ),
          ],
        ),
      ),
    );
  }
}
