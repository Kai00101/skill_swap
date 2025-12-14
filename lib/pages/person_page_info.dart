import 'package:flutter/material.dart';
import 'package:skill_swap/widgets/widget_tree.dart';
import '../services/user_service.dart';

class ProfileFormPage extends StatefulWidget {
  const ProfileFormPage({super.key});

  @override
  State<ProfileFormPage> createState() => _ProfileFormPageState();
}

class _ProfileFormPageState extends State<ProfileFormPage> {

  final nameController = TextEditingController();
  final cityController = TextEditingController();
  final teachController = TextEditingController();
  final learnController = TextEditingController();

  List<String> canTeach = [];
  List<String> wantsToLearn = [];

  String? error;



  void addTeach() {
    final v = teachController.text.trim();
    if (v.isNotEmpty) {
      setState(() {
        canTeach.add(v);
        teachController.clear();
      });
    }
  }

  void addLearn() {
    final v = learnController.text.trim();
    if (v.isNotEmpty) {
      setState(() {
        wantsToLearn.add(v);
        learnController.clear();
      });
    }
  }



  Future<void> save() async {
    final name = nameController.text.trim();
    final city = cityController.text.trim();

    if (name.isEmpty || city.isEmpty || canTeach.isEmpty || wantsToLearn.isEmpty) {
      setState(() => error = "Заполните все поля и добавьте навыки");
      return;
    }

    await UserService.saveProfile(
      name: name,
      city: city,
      canTeach: canTeach,
      wantsToLearn: wantsToLearn,
      skipped: [],
      blocked: [],
    );

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => WidgetTree()),
    );
  }



  Widget inputBox({
    required TextEditingController controller,
    required String hint,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F8),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: controller,
        decoration: const InputDecoration(border: InputBorder.none),
        style: const TextStyle(fontSize: 15),
      ),
    );
  }

  Widget chipList(List<String> list) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(list.length, (i) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFE6DDFA),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(list[i], style: const TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: () => setState(() => list.removeAt(i)),
                child: const Icon(Icons.close, size: 16),
              )
            ],
          ),
        );
      }),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Profile")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [


            const Text("Name"),
            const SizedBox(height: 6),
            inputBox(controller: nameController, hint: "Your name"),
            const SizedBox(height: 14),


            const Text("City"),
            const SizedBox(height: 6),
            inputBox(controller: cityController, hint: "Your city"),

            const SizedBox(height: 25),


            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Skills you can teach",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextButton.icon(
                  onPressed: addTeach,
                  icon: const Icon(Icons.add),
                  label: const Text("Add skill"),
                )
              ],
            ),

            inputBox(controller: teachController, hint: "Add new skill"),
            const SizedBox(height: 10),
            chipList(canTeach),

            const SizedBox(height: 25),


            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Skills you want to learn",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextButton.icon(
                  onPressed: addLearn,

                  icon: const Icon(Icons.add),
                  label: const Text("Add skill"),
                )
              ],
            ),

            inputBox(controller: learnController, hint: "Add new skill"),
            const SizedBox(height: 10),
            chipList(wantsToLearn),

            if (error != null) ...[
              const SizedBox(height: 12),
              Text(error!, style: const TextStyle(color: Colors.red)),
            ],

            const SizedBox(height: 35),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6F4CC2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: save,
                child: const Text(
                  "SAVE PROFILE",
                  style: TextStyle(
                      color:Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
