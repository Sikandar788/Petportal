import 'package:flutter/material.dart';

class ChatBot extends StatefulWidget {
  const ChatBot({super.key});

  @override
  State<ChatBot> createState() => _ChatBot();
}

class _ChatBot extends State<ChatBot> {
  TextEditingController controller = TextEditingController();

  List<Map<String, String>> messages = [
    {
      "type": "bot",
      "text": "Hello! Welcome to Pet Portal Chatbot 👋"
    },
    {
      "type": "bot",
      "text": "How can I help you today?"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pet Portal Chatbot"),
        backgroundColor: Colors.teal,
      ),

      body: Column(
        children: [

          // ================= CHAT LIST =================
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                bool isUser = messages[index]["type"] == "user";

                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      color: isUser
                          ? Colors.teal.shade300
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(messages[index]["text"] ?? ""),
                  ),
                );
              },
            ),
          ),

          // ================= QUICK BUTTONS =================
          SizedBox(
            height: 45,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                quickButton("Add Pet"),
                quickButton("Diet"),
                quickButton("Reminder"),
                quickButton("Training"),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // ================= INPUT AREA =================
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [

                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: "Type message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                CircleAvatar(
                  backgroundColor: Colors.teal,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: () {
                      // UI only - just show message in list
                      setState(() {
                        messages.add({
                          "type": "user",
                          "text": controller.text,
                        });

                        controller.clear();
                      });
                    },
                  ),
                ),

              ],
            ),
          ),

        ],
      ),
    );
  }

  // ================= QUICK BUTTON =================
  Widget quickButton(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
        onPressed: () {
          setState(() {
            messages.add({
              "type": "user",
              "text": text,
            });
          });
        },
        child: Text(text),
      ),
    );
  }
}