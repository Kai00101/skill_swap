import 'package:flutter/material.dart';
import '../../services/user_service.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {

  final nameController = TextEditingController();
  final cityController = TextEditingController();
  final teachController = TextEditingController();
  final learnController = TextEditingController();

  List<String> canTeach = [];
  List<String> wants = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final user = await UserService.getMyProfile();
    if (user == null) return;

    setState(() {
      nameController.text = user.name;
      cityController.text = user.city;
      canTeach = List.from(user.canTeach);
      wants = List.from(user.wantsToLearn);
      loading = false;
    });
  }

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
        wants.add(v);
        learnController.clear();
      });
    }
  }

  Future<void> save() async {
    await UserService.updateProfile(
      name: nameController.text.trim(),
      city: cityController.text.trim(),
      canTeach: canTeach,
      wantsToLearn: wants,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Saved!")),
    );

    Navigator.pop(context);
  }

  Widget chipList(List<String> list, void Function(int) onDelete) {
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
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
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
            chipList(canTeach, (_) {}),
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
            chipList(wants, (_) {}),

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
                  "SAVE CHANGES",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
