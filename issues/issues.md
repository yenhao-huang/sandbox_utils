issues: authentication, mount volume, firmware (gpu)
1. add ssh-key -> sol: add library and copy ssh-key to new directory
2. no correct permission -> sol: set user/group id to "howard"(me)
3. cannot read model -> sol: mount model/data to the container
4. no permission to read model directory (reason: that directory's owner is not howard while its group contain howard) -> sol: mount the directory I have permission to use
5. no gpu
