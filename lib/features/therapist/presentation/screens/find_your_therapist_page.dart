import 'package:flutter/material.dart';
import 'package:inner_bloom_app/constants/strings.dart';
import 'package:inner_bloom_app/core/models/therapist.dart';
import 'package:inner_bloom_app/core/repository/therapist_repository.dart';
import 'package:inner_bloom_app/core/services/therapist_service.dart';
import 'package:inner_bloom_app/features/therapist/models/therapist_item.dart';
import 'package:inner_bloom_app/features/therapist/presentation/screens/book_session_page.dart';
import 'package:inner_bloom_app/features/therapist/presentation/screens/therapist_chat_page.dart';

class FindTherapistPage extends StatefulWidget {
  const FindTherapistPage({super.key});

  @override
  State<FindTherapistPage> createState() => _FindTherapistPageState();
}

class _FindTherapistPageState extends State<FindTherapistPage> {
  late List<Therapist> _therapistData;
  late final TherapistRepository therapistRepository;

  final TextEditingController _searchCtrl = TextEditingController();
  late final List<TherapistItem> _allTherapists = _mockTherapists();
  List<TherapistItem> _filtered = [];
  String _activeLanguageFilter = 'All';
  RangeValues _ratingRange = const RangeValues(0.0, 5.0);

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _filtered = List.from(_allTherapists);
    _searchCtrl.addListener(_onSearchChanged);

    therapistRepository = TherapistRepository(TherapistService());

    _fetchTherapistData();
  }

  Future<void> _fetchTherapistData() async {
    await therapistRepository.init();
  }

  void _onSearchChanged() {
    final q = _searchCtrl.text.trim().toLowerCase();
    _applyFilters(
      searchQuery: q,
      language: _activeLanguageFilter,
      ratingRange: _ratingRange,
    );
  }

  void _applyFilters({
    String? searchQuery,
    String? language,
    RangeValues? ratingRange,
  }) {
    final q = (searchQuery ?? _searchCtrl.text).trim().toLowerCase();
    final lang = (language ?? _activeLanguageFilter);
    final ratingMin = ratingRange?.start ?? _ratingRange.start;
    final ratingMax = ratingRange?.end ?? _ratingRange.end;

    setState(() {
      _filtered = _allTherapists.where((t) {
        final matchesLang = lang == 'All' || t.languages.contains(lang);
        final matchesQuery =
            q.isEmpty ||
            t.name.toLowerCase().contains(q) ||
            t.title.toLowerCase().contains(q) ||
            t.languages.join(' ').toLowerCase().contains(q);
        final matchesRating = t.rating >= ratingMin && t.rating <= ratingMax;
        return matchesLang && matchesQuery && matchesRating;
      }).toList();
    });
  }

  void _openTherapistDetail(Therapist t) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _buildDetailSheet(t);
      },
    );
  }

  /// Build and show filter panel bottom sheet.
  Future<void> _openFilterPanel() async {
    String tmpLanguage = _activeLanguageFilter;
    RangeValues tmpRating = _ratingRange;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 56),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 48,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Filters',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 20),

                    const Text(
                      'Language',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 10),

                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _buildLanguageList().map((lang) {
                        final isSelected = tmpLanguage == lang;

                        return ChoiceChip(
                          label: Text(lang),
                          selected: isSelected,
                          onSelected: (_) {
                            setSheetState(() => tmpLanguage = lang);
                          },
                          selectedColor: Colors.green.shade100,
                          backgroundColor: Colors.grey.shade100,
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      'Rating range',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 10),

                    RangeSlider(
                      values: tmpRating,
                      min: 0,
                      max: 5,
                      divisions: 10,
                      labels: RangeLabels(
                        tmpRating.start.toStringAsFixed(1),
                        tmpRating.end.toStringAsFixed(1),
                      ),
                      onChanged: (r) => setSheetState(() => tmpRating = r),
                    ),

                    const SizedBox(height: 24),

                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _activeLanguageFilter = tmpLanguage;
                                _ratingRange = tmpRating;
                              });
                              _applyFilters(
                                language: _activeLanguageFilter,
                                ratingRange: _ratingRange,
                              );
                              Navigator.pop(context);
                            },
                            child: const Text('Apply filters'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  List<String> _buildLanguageList() {
    final langs = <String>{'All'};
    for (final t in _allTherapists) {
      langs.addAll(t.languages);
    }
    final list = langs.toList();
    list.sort((a, b) {
      if (a == 'All') return -1;
      if (b == 'All') return 1;
      return a.compareTo(b);
    });
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: Colors.teal.shade700),
        title: const Text(
          'Find Your Therapist',
          style: TextStyle(color: Colors.teal, fontWeight: FontWeight.w700),
        ),
        titleSpacing: 0,
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              children: [
                if (_activeLanguageFilter != 'All')
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _activeLanguageFilter,
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: _openFilterPanel,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),

                    child: Row(
                      children: [
                        Icon(Icons.filter_list, color: Colors.grey.shade700),
                        const SizedBox(width: 6),
                        const Text('Filter'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildSearchBar(),
            ),

            if (!(_ratingRange.start <= 0.001 && _ratingRange.end >= 4.999))
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                child: Row(
                  children: [
                    Text(
                      'Rating: ${_ratingRange.start.toStringAsFixed(1)} - ${_ratingRange.end.toStringAsFixed(1)}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _ratingRange = const RangeValues(0.0, 5.0);
                        });
                        _applyFilters(
                          language: _activeLanguageFilter,
                          ratingRange: _ratingRange,
                        );
                      },
                      child: const Text('Reset rating'),
                    ),
                  ],
                ),
              ),
            Expanded(child: _buildGrid()),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSheet(Therapist t) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 56),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // let column size to content

          children: [
            Center(
              child: Container(
                width: 46,
                height: 6,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),

            Row(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundImage: AssetImage(avatarPlaceholder),
                  backgroundColor: Colors.grey.shade100,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        t.aboutDetails,
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.orange.shade400,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${t.rating} • ${t.totalReviews} reviews',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Wrap(
              spacing: 8,
              children: t.languages
                  .map(
                    (l) => Chip(
                      label: Text(l),
                      backgroundColor: Colors.green.shade50,
                    ),
                  )
                  .toList(),
            ),

            const SizedBox(height: 16),

            const Text('About', style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text(
              t.aboutDetails,
              style: TextStyle(color: Colors.grey.shade800, height: 1.4),
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              TherapistChatPage(therapistName: t.name),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Message'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              BookSessionPage(therapistName: t.name),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Book Session'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: TextField(
        controller: _searchCtrl,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          hintText: 'Search by name, language or speciality',
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey.shade100,
        ),
      ),
    );
  }

  Widget _buildGrid() {
    return StreamBuilder(
      stream: therapistRepository.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: const CircularProgressIndicator());
        }

        _therapistData = snapshot.data ?? [];

        if (_therapistData.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Text('No therapists found'),
            ),
          );
        }

        return GridView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          physics: const BouncingScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.05,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: _therapistData.length,
          itemBuilder: (_, idx) => _buildTherapistCard(_therapistData[idx]),
          shrinkWrap: true,
        );
      },
    );
  }

  Widget _buildTherapistCard(Therapist t) {
    return InkWell(
      onTap: () => _openTherapistDetail(t),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              CircleAvatar(
                radius: 36,
                backgroundImage: AssetImage(avatarPlaceholder),
                backgroundColor: Colors.grey.shade50,
              ),
              const SizedBox(height: 10),
              Text(t.name, style: const TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text(
                t.name,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star, color: Colors.orange.shade400, size: 14),
                  const SizedBox(width: 6),
                  Text(
                    '${t.rating}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '(${t.totalReviews})',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Mock data - replace with API or Firestore fetch
  List<TherapistItem> _mockTherapists() {
    return List.generate(12, (i) {
      return TherapistItem(
        id: 't-$i',
        name: 'Therapist ${i + 1}',
        title: 'Counsellor / Therapist',
        languages: i % 3 == 0
            ? ['English', 'Malay', 'Mandarin', 'Tamil']
            : ['English', 'Malay'],
        rating: double.parse((4.0 + (i % 5) * 0.1).toStringAsFixed(1)),
        reviews: 5 + i * 3,
        avatar: placeholderAvatar,
        bio:
            'Experienced counsellor specialising in anxiety, stress and workplace wellbeing. Offers confidential and culturally aware support.',
      );
    });
  }

  @override
  void dispose() {
    _searchCtrl.removeListener(_onSearchChanged);
    _searchCtrl.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
