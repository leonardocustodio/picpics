import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:picpics/utils/app_logger.dart';
import 'package:picpics/widgets/app_header.dart';
import 'package:picpics/widgets/toggle_bar.dart';

/// Widget tests for core UI components
/// Tests rendering, interactions, and visual states
void main() {
  setUpAll(AppLogger.init);

  group('ToggleBar Widget Tests', () {
    testWidgets('renders with correct initial state', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ToggleBar(
              titleLeft: 'Photos',
              titleRight: 'Albums',
              activeToggle: 0,
              onToggle: (_) {},
            ),
          ),
        ),
      );

      // Verify both labels are displayed (at least one of each)
      expect(find.text('Photos'), findsWidgets);
      expect(find.text('Albums'), findsWidgets);
    });

    testWidgets('tapping left option calls onToggle with 0', (tester) async {
      var toggledValue = -1;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ToggleBar(
              titleLeft: 'Photos',
              titleRight: 'Albums',
              activeToggle: 1, // Start with right active
              onToggle: (value) {
                toggledValue = value;
              },
            ),
          ),
        ),
      );

      // Tap on first "Photos" text (the visible CupertinoButton one)
      await tester.tap(find.text('Photos').first);
      await tester.pump();

      expect(toggledValue, 0);
    });

    testWidgets('tapping right option calls onToggle with 1', (tester) async {
      var toggledValue = -1;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ToggleBar(
              titleLeft: 'Photos',
              titleRight: 'Albums',
              activeToggle: 0, // Start with left active
              onToggle: (value) {
                toggledValue = value;
              },
            ),
          ),
        ),
      );

      // Tap on first "Albums" text (the visible CupertinoButton one)
      await tester.tap(find.text('Albums').first);
      await tester.pump();

      expect(toggledValue, 1);
    });

    testWidgets('has Container with height 44', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ToggleBar(
              titleLeft: 'Photos',
              titleRight: 'Albums',
              activeToggle: 0,
              onToggle: (_) {},
            ),
          ),
        ),
      );

      // Find Container widgets
      final containers = tester.widgetList<Container>(find.byType(Container));
      final hasHeight44 = containers.any((c) => c.constraints?.maxHeight == 44);
      expect(hasHeight44, isTrue);
    });

    testWidgets('displays custom titles correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ToggleBar(
              titleLeft: 'Day',
              titleRight: 'Month',
              activeToggle: 0,
              onToggle: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Day'), findsWidgets);
      expect(find.text('Month'), findsWidgets);
    });

    testWidgets('toggle callback is invoked correctly', (tester) async {
      var activeIndex = 0;

      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return MaterialApp(
              home: Scaffold(
                body: ToggleBar(
                  titleLeft: 'Photos',
                  titleRight: 'Albums',
                  activeToggle: activeIndex,
                  onToggle: (value) {
                    setState(() {
                      activeIndex = value;
                    });
                  },
                ),
              ),
            );
          },
        ),
      );

      // Tap to toggle
      await tester.tap(find.text('Albums').first);

      // Pump through animation (300ms duration)
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 150));
      await tester.pump(const Duration(milliseconds: 150));

      expect(activeIndex, 1);
    });

    testWidgets('uses backdrop filter for blur effect', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ToggleBar(
              titleLeft: 'Photos',
              titleRight: 'Albums',
              activeToggle: 0,
              onToggle: (_) {},
            ),
          ),
        ),
      );

      expect(find.byType(BackdropFilter), findsOneWidget);
    });

    testWidgets('multiple toggles work correctly', (tester) async {
      final toggleHistory = <int>[];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ToggleBar(
              titleLeft: 'Photos',
              titleRight: 'Albums',
              activeToggle: 0,
              onToggle: toggleHistory.add,
            ),
          ),
        ),
      );

      // Toggle multiple times
      await tester.tap(find.text('Albums').first);
      await tester.pump();
      await tester.tap(find.text('Photos').first);
      await tester.pump();
      await tester.tap(find.text('Albums').first);
      await tester.pump();

      expect(toggleHistory, [1, 0, 1]);
    });

    testWidgets('contains CupertinoButtons for interaction', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ToggleBar(
              titleLeft: 'Photos',
              titleRight: 'Albums',
              activeToggle: 0,
              onToggle: (_) {},
            ),
          ),
        ),
      );

      // Should have at least 2 CupertinoButtons (left and right toggle)
      expect(find.byType(CupertinoButton), findsAtLeastNWidgets(2));
    });

    testWidgets('renders ClipRRect for rounded corners', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ToggleBar(
              titleLeft: 'Photos',
              titleRight: 'Albums',
              activeToggle: 0,
              onToggle: (_) {},
            ),
          ),
        ),
      );

      expect(find.byType(ClipRRect), findsOneWidget);
    });
  });

  group('ToggleBar Edge Cases', () {
    testWidgets('handles empty titles gracefully', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ToggleBar(
              titleLeft: '',
              titleRight: '',
              activeToggle: 0,
              onToggle: (_) {},
            ),
          ),
        ),
      );

      // Should render without errors
      expect(find.byType(ToggleBar), findsOneWidget);
    });

    testWidgets('handles long titles', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ToggleBar(
              titleLeft: 'Very Long Title Left',
              titleRight: 'Very Long Title Right',
              activeToggle: 0,
              onToggle: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Very Long Title Left'), findsWidgets);
      expect(find.text('Very Long Title Right'), findsWidgets);
    });

    testWidgets('handles unicode characters in titles', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ToggleBar(
              titleLeft: '日本語',
              titleRight: 'Test',
              activeToggle: 0,
              onToggle: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('日本語'), findsWidgets);
      expect(find.text('Test'), findsWidgets);
    });

    testWidgets('toggle remains functional after rebuild', (tester) async {
      var activeIndex = 0;
      var rebuildCount = 0;

      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            rebuildCount++;
            return MaterialApp(
              home: Scaffold(
                body: ToggleBar(
                  titleLeft: 'Photos',
                  titleRight: 'Albums',
                  activeToggle: activeIndex,
                  onToggle: (value) {
                    setState(() {
                      activeIndex = value;
                    });
                  },
                ),
              ),
            );
          },
        ),
      );

      final initialRebuildCount = rebuildCount;

      // Toggle twice
      await tester.tap(find.text('Albums').first);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Photos').first);
      await tester.pumpAndSettle();

      // Should have rebuilt multiple times
      expect(rebuildCount, greaterThan(initialRebuildCount));
      expect(activeIndex, 0);
    });
  });

  group('ToggleBar Animation', () {
    testWidgets('AnimatedAlign is present', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ToggleBar(
              titleLeft: 'Photos',
              titleRight: 'Albums',
              activeToggle: 0,
              onToggle: (_) {},
            ),
          ),
        ),
      );

      expect(find.byType(AnimatedAlign), findsOneWidget);
    });

    testWidgets('animation duration is 300ms', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ToggleBar(
              titleLeft: 'Photos',
              titleRight: 'Albums',
              activeToggle: 0,
              onToggle: (_) {},
            ),
          ),
        ),
      );

      final animatedAlign = tester.widget<AnimatedAlign>(
        find.byType(AnimatedAlign),
      );
      expect(animatedAlign.duration, const Duration(milliseconds: 300));
    });
  });

  group('ToggleBar Styling', () {
    testWidgets('uses Lato font family', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ToggleBar(
              titleLeft: 'Photos',
              titleRight: 'Albums',
              activeToggle: 0,
              onToggle: (_) {},
            ),
          ),
        ),
      );

      // Find all text widgets and check if any has Lato font
      final textWidgets = tester.widgetList<Text>(find.byType(Text));
      final hasLatoFont = textWidgets.any((t) => t.style?.fontFamily == 'Lato');
      expect(hasLatoFont, isTrue);
    });

    testWidgets('has correct background color with alpha', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ToggleBar(
              titleLeft: 'Photos',
              titleRight: 'Albums',
              activeToggle: 0,
              onToggle: (_) {},
            ),
          ),
        ),
      );

      // Find Container with the background decoration
      final containers = tester.widgetList<Container>(find.byType(Container));
      final hasCorrectDecoration = containers.any((c) {
        if (c.decoration is BoxDecoration) {
          final decoration = c.decoration! as BoxDecoration;
          return decoration.color?.alpha == (0.8 * 255).round();
        }
        return false;
      });

      // The container should have semi-transparent background
      expect(hasCorrectDecoration, isTrue);
    });
  });

  group('AppHeader Widget Tests', () {
    testWidgets('renders with default logo', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: const AppHeader(),
          ),
        ),
      );

      // Should find the AppHeader widget
      expect(find.byType(AppHeader), findsOneWidget);

      // Should have a Row for layout
      expect(find.byType(Row), findsAtLeastNWidgets(1));

      // Should have a CupertinoButton for settings
      expect(find.byType(CupertinoButton), findsOneWidget);
    });

    testWidgets('has correct height of 44', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: const AppHeader(),
          ),
        ),
      );

      // Find SizedBox with height 44
      final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
      final hasCorrectHeight = sizedBoxes.any((sb) => sb.height == 44);
      expect(hasCorrectHeight, isTrue);
    });

    testWidgets('has correct padding', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: const AppHeader(),
          ),
        ),
      );

      // Find Padding widget with correct values
      final paddings = tester.widgetList<Padding>(find.byType(Padding));
      final hasCorrectPadding = paddings.any((p) {
        if (p.padding is EdgeInsets) {
          final ei = p.padding as EdgeInsets;
          return ei.left == 16 && ei.right == 16 && ei.top == 8 && ei.bottom == 8;
        }
        return false;
      });
      expect(hasCorrectPadding, isTrue);
    });

    testWidgets('renders with custom leading widget', (tester) async {
      const customLeading = Text('Custom Leading');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: const AppHeader(
              leading: customLeading,
            ),
          ),
        ),
      );

      // Should find the custom leading text
      expect(find.text('Custom Leading'), findsOneWidget);
    });

    testWidgets('settings button exists and has onPressed callback', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: const AppHeader(),
          ),
        ),
      );

      // Find the settings button
      final settingsButton = find.byType(CupertinoButton);
      expect(settingsButton, findsOneWidget);

      // Verify the button has an onPressed callback (not null)
      final button = tester.widget<CupertinoButton>(settingsButton);
      expect(button.onPressed, isNotNull);
    });

    testWidgets('contains Expanded widget for flexible layout', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: const AppHeader(),
          ),
        ),
      );

      expect(find.byType(Expanded), findsOneWidget);
    });

    testWidgets('uses Image.asset for logo', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: const AppHeader(),
          ),
        ),
      );

      // Should have Image widgets (logo and settings icon)
      expect(find.byType(Image), findsAtLeastNWidgets(1));
    });

    testWidgets('custom leading replaces logo image', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: const AppHeader(
              leading: Icon(Icons.search),
            ),
          ),
        ),
      );

      // Should find the custom Icon
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('settings button has zero padding', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: const AppHeader(),
          ),
        ),
      );

      final button = tester.widget<CupertinoButton>(find.byType(CupertinoButton));
      expect(button.padding, EdgeInsets.zero);
    });
  });

  group('AppHeader Edge Cases', () {
    testWidgets('handles null leading gracefully (uses default logo)', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: const AppHeader(leading: null),
          ),
        ),
      );

      // Should render without errors
      expect(find.byType(AppHeader), findsOneWidget);
      // Default logo should be shown (as Image)
      expect(find.byType(Image), findsAtLeastNWidgets(1));
    });

    testWidgets('complex leading widget renders correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppHeader(
              leading: Row(
                children: const [
                  Icon(Icons.search),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(hintText: 'Search'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Search'), findsOneWidget);
    });

    testWidgets('maintains structure with various screen sizes', (tester) async {
      // Test with narrow screen
      await tester.binding.setSurfaceSize(const Size(320, 568));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: const AppHeader(),
          ),
        ),
      );

      expect(find.byType(AppHeader), findsOneWidget);
      expect(find.byType(Row), findsAtLeastNWidgets(1));

      // Reset to default
      await tester.binding.setSurfaceSize(null);
    });
  });
}
