import * as pulumi from "@pulumi/pulumi";
import * as gcp from "@pulumi/gcp";

const config = new pulumi.Config("satakuntatalo-foundation");
const organizationId = config.requireSecret("organizationId");

const osakuntaFolder = new gcp.organizations.Folder(
  "osakunta-folder",
  {
    displayName: "osakunta",
    parent: pulumi.interpolate`organizations/${organizationId}`,
  },
  { protect: true }
);

const verkkovastaavaOsakuntaFolderAccess = new gcp.folder.IAMMember(
  "verkkovastaava-osakunta-folder-access",
  {
    folder: osakuntaFolder.id,
    role: "roles/viewer",
    member: "group:verkkovastaava@satakuntalainenosakunta.fi",
  }
);
