import 'package:flutter/material.dart';
import 'package:inner_bloom_app/features/chat/models/chat_message.dart';

import '../widgets/widgets.dart';

class InnerBloomChatPage extends StatefulWidget {
  const InnerBloomChatPage({super.key});

  @override
  State<InnerBloomChatPage> createState() => _InnerBloomChatPageState();
}

class _InnerBloomChatPageState extends State<InnerBloomChatPage> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;

  static const Color primary = Color(0xFF2F5C52);
  static const Color accent = Color(0xFF91B6A9);

  @override
  void initState() {
    super.initState();

    _messages.add(
      ChatMessage(
        text:
            "Hey 🌱 I’m InnerBloom.\nI’m really glad you’re here.\nWhat’s on your mind today?",
        isUser: false,
      ),
    );
  }

  void _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
      _isTyping = true;
      _controller.clear();
    });

    // Simulated AI thinking delay
    await Future.delayed(const Duration(milliseconds: 800));

    setState(() {
      _isTyping = false;
      _messages.add(ChatMessage(text: _mockReply(text), isUser: false));
    });
  }

  String _mockReply(String input) {
    return "That sounds important 💛\nDo you want to talk more about it, or would you like a gentle suggestion?";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFEFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: Colors.teal.shade700),
        title: const Text(
          'InnerBloom',
          style: TextStyle(color: Colors.teal, fontWeight: FontWeight.w700),
        ),
        titleSpacing: 0,
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: _buildChatList()),
            if (_isTyping) const TypingIndicator(),
            _buildQuickReplies(),
            _buildInputBar(),
          ],
        ),
      ),
    );
  }

  // =============================
  // CHAT LIST
  // =============================
  Widget _buildChatList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: _messages.length,
      itemBuilder: (_, index) {
        final msg = _messages[index];
        return ChatBubble(message: msg);
      },
    );
  }

  // =============================
  // QUICK REPLIES
  // =============================
  Widget _buildQuickReplies() {
    final replies = [
      "I feel stressed 😣",
      "I need motivation ⚡",
      "Help me calm down 🌿",
    ];

    return SizedBox(
      height: 44,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemCount: replies.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          return QuickReplyChip(
            label: replies[i],
            onTap: () => _sendMessage(replies[i]),
          );
        },
      ),
    );
  }

  // =============================
  // INPUT BAR
  // =============================
  Widget _buildInputBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      child: Row(
        children: [
          Expanded(
            child: Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(16),
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: "Type how you feel…",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          FloatingActionButton(
            mini: true,
            backgroundColor: accent,
            elevation: 2,
            onPressed: () => _sendMessage(_controller.text),
            child: const Icon(Icons.send, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
