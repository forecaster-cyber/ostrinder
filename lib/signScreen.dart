import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ostrinder/profilePage.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';


class SignScreen extends StatefulWidget {
  const SignScreen({super.key, required this.redirectTo});
  final String redirectTo;
  @override
  State<SignScreen> createState() => _SignScreenState();
}

class _SignScreenState extends State<SignScreen> {
  @override
  void initState() {
    print(widget.redirectTo);
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('התחברות'),
      ),
      body: Column(
        children: [
          SupaEmailAuth(
            redirectTo: kIsWeb ? null : 'io.mydomain.myapp://callback',
            onSignInComplete: (response) {
              setState(() {
                if (widget.redirectTo == "profile") {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/profile')
                      .then((value) => setState(() {}));
                } else if (widget.redirectTo == "home") {
                  Navigator.pop(context);
                }
              });
            },
            onSignUpComplete: (response) {
              setState(() {
                if (widget.redirectTo == "profile") {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/profile')
                      .then((value) => setState(() {}));
                } else if (widget.redirectTo == "home") {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/')
                      .then((value) => setState(() {}));
                }
              });
            },
            metadataFields: [
              MetaDataField(
                prefixIcon: const Icon(Icons.person),
                label: 'Username',
                key: 'username',
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'אנא הקלד משהו';
                  }
                  return null;
                },
              ),
            ],
          ),
          SupaSocialsAuth(
            socialProviders: [
              SocialProviders.google,
            ],
            colored: true,
            redirectUrl:
                kIsWeb ? null : 'io.supabase.flutter://reset-callback/',
            onSuccess: (Session response) {
              // do something, for example: navigate('home');
            },
            onError: (error) {
              // do something, for example: navigate("wait_for_email");
            },
          ),
        ],
      ),
    );
  }
}
