import 'package:turbo_firestore_api_example/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:turbo_mvvm/turbo_mvvm.dart';

class CloudFirestoreApiViewModel extends TViewModel {
  CloudFirestoreApiViewModel();

  @override
  Future<void> initialise() async {
    await Firebase.initializeApp();
    ExampleAPI().createExample();
    super.initialise();
  }

  static CloudFirestoreApiViewModel get locate => CloudFirestoreApiViewModel();
}
