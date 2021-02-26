
class ProjectPickerItem {
}

class ProjectPickerHeadlineItem extends ProjectPickerItem {
  ProjectPickerHeadlineItem(this.text);
  String text;
}

class ProjectPickerOrganizationItem extends ProjectPickerItem {
  ProjectPickerOrganizationItem(this.title);
  String title;
}

class ProjectPickerProjectItem extends ProjectPickerItem {
  ProjectPickerProjectItem(this.organizationSlug, this.projectSlug, this.title, this.isBookmarked);

  final String organizationSlug;
  final String projectSlug;

  String title;
  bool isBookmarked;
}