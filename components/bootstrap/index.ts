import * as pulumi from "@pulumi/pulumi";
import * as gcp from "@pulumi/gcp";

const config = new pulumi.Config("osakunta-foundation");
const organizationId = config.requireSecret("organizationId");
const billingAccount = config.requireSecret("billingAccount");

const gcpConfig = new pulumi.Config("gcp");
const projectId = gcpConfig.require("project");
const region = gcpConfig.require("region");

const APIS_TO_ENABLE = [
  "cloudresourcemanager.googleapis.com",
  "compute.googleapis.com",
];

class BootstrapProject extends pulumi.ComponentResource {
  apis: Record<string, gcp.projects.Service> = {};
  pulumiStateBucket: gcp.storage.Bucket;

  constructor(name: string, opts?: pulumi.ResourceOptions) {
    super("satakuntatalo:resource:BootstrapProject", name, {}, opts);

    for (const api of APIS_TO_ENABLE) {
      this.apis[api] = new gcp.projects.Service(
        `foundation-project-${api}`,
        {
          service: api,
        },
        {
          parent: this,
        }
      );
    }

    this.pulumiStateBucket = new gcp.storage.Bucket(
      "pulumi-state-bucket",
      {
        name: `${projectId}-pulumi-state`,
        location: region,
        storageClass: "STANDARD",
        publicAccessPrevention: "enforced",
      },
      {
        parent: this,
        protect: true,
      }
    );
  }
}

/* This file could just be a module that defines all the resources necessary for bootstrapping.
 * However, grouping them into a custom component makes it easier to define the other resources as
 * dependent on the bootstrapping having been done first.
 */

export const bootstrapProject = new BootstrapProject("bootstrap-project");
