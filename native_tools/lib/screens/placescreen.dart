import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_tools/providers/userdata.dart';
import 'package:native_tools/screens/addplace.dart';
import 'package:native_tools/screens/placedetail.dart';

class Placescreen extends ConsumerWidget {
  const Placescreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userplaces = ref.watch(userdataprovider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Great Places'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => const Addplace(),
                ),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: userplaces.isEmpty
            ? const Center(
                child: Text('No places added yet.'),
              )
            : ListView.builder(
                itemCount: userplaces.length,
                itemBuilder: (ctx, index) => ListTile(
                  leading: CircleAvatar(
                    radius: 26,
                    backgroundImage: FileImage(userplaces[index].image),
                  ),
                  title: Text(
                    userplaces[index].title,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                  ),
                  subtitle: Text(
                    userplaces[index].location.address,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => Placedetail(
                          place: userplaces[index],
                        ),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
