# NixOS on Raspberry Pi

My personal NixOS setup on Raspberry Pi

Model:
 - Pi 3B+

# Using prebuilt image available on Hydra

The latest image is on Hydra:

[sd-image](https://hydra.nixos.org/job/nixos/release-20.09/nixos.sd_image.aarch64-linux/latest/download-by-type/file/sd-image)

If the image have extension .img.zst , then you need to uncompress it.

```bash
unzstd sd-image.img.zst
```

Flash the image to your sd card using dd. Follow the instruction in NixOS [wiki](https://nixos.wiki/wiki/NixOS_on_ARM#Installation_steps) that links to the raspberry pi original docs.

With this setup, you have a bare minimum image that you can access via HDMI and keyboard.

Further configuration are done via `/etc/nixos/configuration.nix` (the image is a NixOS).
Create the file and fill in your configuration.
Here's some example from mine: [configuration.nix](configuration.nix)

Build the configuration

```
nixos-rebuild test -p test
```

This will build the configuration but not set it as the default boot. You can try if everything works okay and then reboot. From the boot menu, choose this profile to test if everything works after reboot. If you do nothing in the boot menu, it will choose your last default profile instead of this `test` profile.
It is also possible to create different nixos-config file and build it accordingly to test several config:

```
nixos-rebuild test -p test-1 -I nixos-config=./test.nix
```

# Building using Github Action

We can leverage Github Action to build our image. We can reuse existing action to setup qemu-user-static and then build and deploy the image as workflow artifact. You can then download the artifact from Github, which is the zipped sd-image.img file.

I already setup a workflow manual dispatch Github Action in this repo, so to build your own customized NixOS raspi image, follow this steps.

1. Fork the repo so you can build your own custom image
2. Create your build/deployment environment. 

From your repo settings page, click the Environments menu. Click New environment. Give it a name other than `default`. Define environment secrets called `CONFIGURATION_NIX`. The content should be your sd Image Nix recipe (not your future NixOS configuration.nix). See the sample template file in: [configuration.default.sdImage.nix](configuration.default.sdImage.nix) or [configuration.sdImage.nix](configuration.sdImage.nix)

3. Run your workflow

In the Actions page, select `nix-build-on-demand-docker` action and then click `Run workflow`. You will be given an option to specify the environment name. Fill in the name of the environment you set up in step 2. Click Run workflow. If you use `default` environment name, it will build [configuration.default.sdImage.nix](configuration.default.sdImage.nix) as the recipe.

4. Wait for it to finish

5. Retrieve the artifact

When the build finish, in your action job page, there will be Artifacts panel with artifacts named `sd-image.img`. Click on it and it will download a zipped file. Extract the zipfile and it will contain the image, as `.img` or `.img.zstd` depending on your config you provided.
