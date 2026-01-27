import 'package:turbo_promptable/turbo_promptable.dart';

void main() {
  // Create a team structure using MetaDataDto
  final team = TeamDto(
    areas: [
      AreaDto(
        roles: [
          RoleDto(
            expertise: ExpertiseDto(
              field: 'Backend',
              specialization: 'API Development',
              experience: '5 years',
            ),
          ),
        ],
      ),
    ],
  );

  final xml = team.toXml();
  // ignore: avoid_print
  print(xml);
}
