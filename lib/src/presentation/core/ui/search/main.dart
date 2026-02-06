import 'dart:async';
import 'package:flutter/material.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/domain/entities/main.dart';
import 'package:labs/src/infraestructure/utils/search_fields.dart';
import 'package:labs/src/presentation/core/ui/custom_desktop_body/main.dart';
import 'view_model.dart';

class SearchTemplateConfig {
  final Widget rightWidget;
  final Alignment alignment;
  final List<SearchFields>? searchFields;
  final Function(List<SearchInput> search)? onSearchChanged;
  final Function(PageInfo pageInfo)? onPageInfoChanged;
  final PageInfo? pageInfo;
  final String? searchHint; // Label personalizado para el campo de búsqueda

  const SearchTemplateConfig({
    this.rightWidget = const SizedBox.shrink(),
    this.alignment = Alignment.centerRight,
    this.onSearchChanged,
    this.onPageInfoChanged,
    this.searchFields,
    this.pageInfo,
    this.searchHint,
  });
}

class SearchTemplate extends StatefulWidget {
  final Widget child;
  final SearchTemplateConfig config;

  const SearchTemplate({
    super.key,
    required this.child,
    this.config = const SearchTemplateConfig(),
  });

  @override
  State<SearchTemplate> createState() => _SearchTemplateState();
}

class _SearchTemplateState extends State<SearchTemplate> {
  Timer? _debounce;
  late ViewModel viewModel;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    viewModel = ViewModel(fields: widget.config.searchFields ?? []);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final configPageInfo = widget.config.pageInfo;
    viewModel.pageInfo = configPageInfo != null
        ? PageInfo(
            total: configPageInfo.total,
            page: configPageInfo.page,
            pages: configPageInfo.pages,
            split: configPageInfo.split <= 0 ? 10 : configPageInfo.split,
          )
        : PageInfo(total: 0, page: 1, pages: 0, split: 10);
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        num total = viewModel.pageInfo.split * viewModel.pageInfo.page;
        if (total > viewModel.pageInfo.total) {
          total = viewModel.pageInfo.total;
        }
        return CustomDesktopBody(
          childWidget: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              child: Flex(
                direction: Axis.vertical,
                children: [
                  Flexible(
                    flex: 0,
                    child: Flex(
                      direction: Axis.horizontal,
                      children: [
                        SizedBox(
                          width: 350,
                          child: TextFormField(
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search),
                              labelText: widget.config.searchHint ?? AppLocalizations.of(context)!.search,
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              if (_debounce?.isActive ?? false) {
                                _debounce!.cancel();
                              }
                              _debounce = Timer(
                                const Duration(milliseconds: 800),
                                () {
                                  if (widget.config.onSearchChanged != null) {
                                    viewModel.search = value;
                                    if (widget.config.onSearchChanged != null) {
                                      widget.config.onSearchChanged!(
                                        viewModel.searchInputs,
                                      );
                                    }
                                  }
                                },
                              );
                            },
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: widget.config.rightWidget,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: constraints.maxHeight,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [widget.child],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Flexible(
                    flex: 0,
                    child: Flex(
                      direction: Axis.horizontal,
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: // Puedes colocar este widget en el child que tienes sombreado
                                Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'Filas por página:',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                DropdownButton<int>(
                                  value: viewModel.pageInfo.split.toInt(),
                                  style: const TextStyle(fontSize: 18),
                                  underline: SizedBox(),

                                  items:
                                      [10, 20, 30, 50].map((int value) {
                                        return DropdownMenuItem<int>(
                                          value: value,
                                          child: Text('$value'),
                                        );
                                      }).toList(),
                                  onChanged: (value) {
                                    viewModel.split = value!;
                                    if (widget.config.onPageInfoChanged !=
                                        null) {
                                      widget.config.onPageInfoChanged!(
                                        viewModel.pageInfo,
                                      );
                                    }
                                  },
                                ),
                                const SizedBox(width: 24),
                                Text(
                                  '${(viewModel.pageInfo.page * viewModel.pageInfo.split + 1) - viewModel.pageInfo.split} - $total de ${viewModel.pageInfo.total}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                IconButton(
                                  icon: Icon(Icons.chevron_left),
                                  onPressed: () {
                                    if (viewModel.pageInfo.page > 1) {
                                      viewModel.pageInfo.page--;
                                      if (widget.config.onPageInfoChanged !=
                                          null) {
                                        widget.config.onPageInfoChanged!(
                                          viewModel.pageInfo,
                                        );
                                      }
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.chevron_right,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    if (viewModel.pageInfo.page <
                                        viewModel.pageInfo.pages) {
                                      viewModel.pageInfo.page++;
                                      if (widget.config.onPageInfoChanged !=
                                          null) {
                                        widget.config.onPageInfoChanged!(
                                          viewModel.pageInfo,
                                        );
                                      }
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
