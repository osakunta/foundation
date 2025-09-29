import * as pulumi from "@pulumi/pulumi";
import * as gcp from "@pulumi/gcp";
import { bootstrapProject } from "./components/bootstrap";

const config = new pulumi.Config("satakuntatalo-foundation");
const organizationId = config.requireSecret("organizationId");

const orgPolicyAPI = new gcp.projects.Service(
  `foundation-project-orgpolicy.googleapis.com`,
  {
    service: "orgpolicy.googleapis.com",
  },
  { dependsOn: [bootstrapProject] }
);

const disableServiceAccountKeyUpload = new gcp.orgpolicy.Policy(
  "org-policy-iam-disableServiceAccountKeyUpload",
  {
    name: pulumi.interpolate`organizations/${organizationId}/policies/iam.disableServiceAccountKeyUpload`,
    parent: pulumi.interpolate`organizations/${organizationId}`,
    spec: {
      rules: [
        {
          enforce: "TRUE",
        },
      ],
    },
  },
  { dependsOn: [orgPolicyAPI] }
);
