A test has been conducted on Project AndroidStudioProjects and gitTest. The latter is used as a submodule in AndroidStudioProjects using the following command:
1) git submodule add https://github.com/ririripley/gitTest.git
After this command, you can notice that 2 files are added to the project: (1)gitTest (2) .gitmodules
  
If you clone a project with submodule, one more command should be run after executing the "git clone ***" command: (1)git submodule init | git submodule update. In this way, all code of submodules will be pull based on the configuration set in the project.

1.
git pull remote branch into local branch:
The submodule change will not be added to commit together, instead, the change will show in working dir waiting 
to be deal with.


2. 
Usually, it is suggested that you should change submodule in its own repository instead of the main module which includes it. 
1) You can specify which branch the main module should use in the file .gitmodules in your project.
2) Then execute git submodule update --remote
Again, the submodule change will not be added to commit, instead, the change will show in working dir waiting 
to be deal with. Therefore, you should add/commit/push.



In summary, as long as you change the content of submodule in its own directory and specity which branch to use in .gitmodules file and then execute update command. All the branches can keep in pace with the remote branch.


PS:
Remember, the submodule will not be updated the same as other files stored in the priject, only commit id, git url as well as the branch will be synchronized. This well explains the following phenomenon:
(1) change and git add the modified content in submodule, but there still appears indication "changes not staged for commit:"

(2)
