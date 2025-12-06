import 'package:bydgoszcz/core/constants/app_constants.dart';
import 'package:bydgoszcz/models/user_profile.dart';
import 'package:bydgoszcz/presentation/bloc/app_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  int _age = 10;
  final Set<String> _selectedInterests = {};

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _completeOnboarding() {
    if (_formKey.currentState!.validate() && _selectedInterests.isNotEmpty) {
      final profile = UserProfile(
        name: _nameController.text.trim(),
        age: _age,
        interests: _selectedInterests.toList(),
      );

      context.read<AppCubit>().completeOnboarding(profile);
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 32),
                Text(
                  'Witaj w Bydgoszczy!',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Zamień spacer po Bydgoszczy w przygodę',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Jak masz na imię?',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Podaj swoje imię';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                Text(
                  'Ile masz lat?',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Slider(
                  value: _age.toDouble(),
                  min: 7,
                  max: 99,
                  divisions: 92,
                  label: '$_age lat',
                  onChanged: (value) {
                    setState(() {
                      _age = value.toInt();
                    });
                  },
                ),
                const SizedBox(height: 24),
                Text(
                  'Co Cię interesuje?',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView(
                    children: AppConstants.availableInterests.map((interest) {
                      return CheckboxListTile(
                        title: Text(interest),
                        value: _selectedInterests.contains(interest),
                        onChanged: (checked) {
                          setState(() {
                            if (checked == true) {
                              _selectedInterests.add(interest);
                            } else {
                              _selectedInterests.remove(interest);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
                if (_selectedInterests.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      'Wybierz przynajmniej jedno zainteresowanie',
                      style: TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: _completeOnboarding,
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('Zaczynamy przygodę!'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
