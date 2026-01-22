import 'package:flutter/material.dart';
import 'package:turbo_flutter_template/core/infrastructure/views/styling/styling_view_model.dart';
import 'package:turbo_flutter_template/core/ui/enums/emoji.dart';
import 'package:turbo_flutter_template/core/ui/widgets/t_scaffold.dart';
import 'package:turbo_flutter_template/core/ui/widgets/t_sliver_app_bar.dart';
import 'package:turbo_flutter_template/core/ui/widgets/t_sliver_body.dart';
import 'package:turbo_mvvm/turbo_mvvm.dart';
import 'package:turbo_widgets/turbo_widgets.dart';

const List<String> _categoryTitles = [
  'Design',
  'Engineering',
  'Marketing',
  'Operations',
  'People',
  'Finance',
  'Legal',
  'Product',
];

const List<String> _categoryImageUrls = [
  'https://images.unsplash.com/photo-1487014679447-9f8336841d58',
  'https://images.unsplash.com/photo-1521737604893-d14cc237f11d',
  'https://images.unsplash.com/photo-1454165804606-c3d57bc86b40',
  'https://images.unsplash.com/photo-1517245386807-bb43f82c33c4',
];

final List<ImageProvider> _categoryImages = _categoryImageUrls
    .map((url) => NetworkImage(url))
    .toList();

const List<IconData> _categoryIcons = [
  Icons.palette_rounded,
  Icons.code_rounded,
  Icons.campaign_rounded,
  Icons.settings_rounded,
  Icons.people_alt_rounded,
  Icons.payments_rounded,
  Icons.balance_rounded,
  Icons.dashboard_rounded,
];

const String _categoryHeaderTitle = 'Browse categories';
const String _categoryHeaderDescription =
    'Explore curated categories with cards and sections that scale from small lists to rich grids.';

class StylingView extends StatelessWidget {
  const StylingView({super.key});

  ImageProvider? _backgroundForIndex(int index) {
    if (index.isEven) {
      return _categoryImages[index % _categoryImages.length];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) => TViewModelBuilder<StylingViewModel>(
        builder: (context, model, isInitialised, child) {
          if (!isInitialised) {
            return const SizedBox.shrink();
          }

          return TScaffold(
            child: TSliverBody(
              appBar: TSliverAppBar(
                title: 'Styling',
                emoji: Emoji.paintbrush,
                onBackPressed: ({required BuildContext context}) =>
                    Navigator.of(context).pop(),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TCategoryHeader(
                      title: _categoryHeaderTitle,
                      description: _categoryHeaderDescription,
                      backgroundImage: _categoryImages.first,
                    ),
                    const SizedBox(height: 16),
                    TCategorySection(
                      title: 'Featured categories',
                      caption: 'Horizontal list with show-all expansion',
                      itemCount: _categoryTitles.length,
                      maxItems: 6,
                      maxLines: 2,
                      itemBuilder: (context, index) => SizedBox(
                        width: 200,
                        child: TCategoryCard(
                          title: _categoryTitles[index],
                          icon: _categoryIcons[index % _categoryIcons.length],
                          backgroundImage: _backgroundForIndex(index),
                          onPressed: () {},
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TCategorySection(
                      title: 'All categories',
                      caption: 'Grid layout for larger lists',
                      layout: TCategorySectionLayout.grid,
                      gridCrossAxisCount: 2,
                      gridChildAspectRatio: 1.6,
                      itemCount: _categoryTitles.length,
                      itemBuilder: (context, index) => TCategoryCard(
                        title: _categoryTitles[index],
                        icon: _categoryIcons[index % _categoryIcons.length],
                        backgroundImage: _backgroundForIndex(index),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        viewModelBuilder: () => StylingViewModel.locate,
      );
}
