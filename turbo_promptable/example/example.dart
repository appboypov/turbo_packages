import 'package:turbo_promptable/turbo_promptable.dart';

void main() {
  // Create a team structure using MetaDataDto
  final team = TeamDto(
    metaData: MetaDataDto(
      name: 'Engineering',
      description: 'Engineering team',
    ),
    areas: [
      AreaDto(
        metaData: MetaDataDto(
          name: 'Backend',
          description: 'Backend area',
        ),
        roles: [
          RoleDto(
            metaData: MetaDataDto(
              name: 'API Developer',
              description: 'API Developer role',
            ),
            expertise: ExpertiseDto(
              metaData: MetaDataDto(
                name: 'Backend Expertise',
                description: 'Backend development expertise',
              ),
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
  print(xml);
}
