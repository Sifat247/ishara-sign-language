import 'package:flutter/material.dart';
import 'package:ishara_sign/core/models/sign_item.dart';
import 'package:ishara_sign/core/services/local_vault_service.dart';
import 'package:ishara_sign/core/services/sign_database.dart';
import 'package:ishara_sign/core/theme/ishara_theme.dart';

class DictionaryScreen extends StatefulWidget {
  const DictionaryScreen({super.key});

  @override
  State<DictionaryScreen> createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'all';
  List<String> _bookmarkedIds = [];

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    final bookmarks = await LocalVaultService.getBookmarkedSignIds();
    if (mounted) setState(() => _bookmarkedIds = bookmarks);
  }

  @override
  Widget build(BuildContext context) {
    final allSigns = AuthenticSignDatabase.initialSigns;
    final filtered = allSigns.where((sign) {
      final matchesQuery = sign.banglaWord.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          sign.englishWord.toLowerCase().contains(_searchQuery.toLowerCase());
      
      if (_selectedCategory == 'bookmarked') {
        return matchesQuery && _bookmarkedIds.contains(sign.id);
      }
      
      final matchesCat = _selectedCategory == 'all' || sign.category == _selectedCategory;
      return matchesQuery && matchesCat;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('ইশারা অভিধান ও নির্দেশিকা'),
      ),
      body: Column(
        children: [
          // Search Input Bar (Debounced feel)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: 'বাংলা বা ইংরেজিতে ইশারা খুঁজুন...',
                prefixIcon: const Icon(Icons.search_rounded, color: IsharaColors.primaryTeal),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
              ),
            ),
          ),

          // Category Chips & Bookmarked Vault Filter
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                _buildFilterChip('সবগুলো', 'all'),
                _buildFilterChip('সংরক্ষিত ❤️', 'bookmarked'),
                _buildFilterChip('নৈমিত্তিক', 'daily'),
                _buildFilterChip('জরুরি ও স্বাস্থ্য', 'emergency'),
                _buildFilterChip('বর্ণমালা (BdSL)', 'alphabet'),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Results List with the 5 Screen States
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _selectedCategory == 'bookmarked' ? Icons.bookmark_border_rounded : Icons.search_off_rounded,
                            size: 64,
                            color: IsharaColors.textMuted,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _selectedCategory == 'bookmarked'
                                ? 'কোনো সংরক্ষিত ইশারা নেই\nপাঠ চলাকালীন বুকমার্ক আইকনে ট্যাপ করে আপনার প্রিয় ইশারা সংরক্ষণ করুন।'
                                : 'কোনো ইশারা খুঁজে পাওয়া যায়নি\nবানান সঠিক কিনা যাচাই করুন।',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: IsharaColors.textMuted, fontSize: 15, height: 1.5),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: filtered.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, idx) {
                      final item = filtered[idx];
                      final isSaved = _bookmarkedIds.contains(item.id);

                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: IsharaColors.studioBackdrop,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(item.handEmoji, style: const TextStyle(fontSize: 28)),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        item.banglaWord,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: IsharaColors.textDark,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: IsharaColors.goldLight.withValues(alpha: 0.5),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          item.track.toUpperCase(),
                                          style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: IsharaColors.primaryTeal,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item.englishWord,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: IsharaColors.textMuted,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item.gestureHintBn,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                                color: isSaved ? IsharaColors.royalGold : IsharaColors.textMuted,
                              ),
                              onPressed: () async {
                                await LocalVaultService.toggleBookmark(item.id);
                                _loadBookmarks();
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.play_circle_outline_rounded, color: IsharaColors.primaryTeal),
                              onPressed: () {
                                _showSignDetailModal(context, item);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String catKey) {
    final isSelected = _selectedCategory == catKey;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        selectedColor: IsharaColors.primaryTeal,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : IsharaColors.textDark,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 13,
        ),
        checkmarkColor: Colors.white,
        backgroundColor: Colors.white,
        side: BorderSide(color: isSelected ? IsharaColors.primaryTeal : const Color(0xFFE2E8F0)),
        onSelected: (_) {
          setState(() => _selectedCategory = catKey);
        },
      ),
    );
  }

  void _showSignDetailModal(BuildContext context, SignItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: IsharaColors.studioBackdrop,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(item.handEmoji, style: const TextStyle(fontSize: 72)),
                    const SizedBox(height: 8),
                    Text(
                      '${item.banglaWord} (${item.englishWord})',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              item.descriptionBn,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: IsharaColors.paperCanvas,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.touch_app_rounded, color: IsharaColors.primaryTeal),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'হাত প্রদর্শনের নির্দেশিকা: ${item.gestureHintBn}',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('বন্ধ করুন'),
            ),
          ],
        ),
      ),
    );
  }
}
