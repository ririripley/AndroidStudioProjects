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
(1) Git add modified content in submodule, but there still appears indication "changes not staged for commit:"
(2) git pull from remote repository, there will appear "modified content(new commit)" ---》 just execute git update --remote to update the submodule and commit and push the change. 
The command "git submodule update --remote" will by default update and checkout to the branch specified in .gitsubmodule file. If you git pull without executing this command, the submodule still remains unchanged, when you execute "git submodule status", the commid id still remains unchanged.   
The command "git submodule update" will just update and checkout to the commit id you specify in the subproject file.
For those untracked files, you can just selete them without hesitation. For modified change, just save and commit.


(3) when you add a submodule to a git repository it tracks a particular commit of that submodule referenced by its sha1.This commit id is stored in Git's object database directly. You can use the command  " git ls-tree master <path-to-directory-containing-submodule> " (or just" git ls-tree master" if the submodule lives in the top-level directory) to see the specified commit id of submodule in supermodule, which matches the id from command "git submodule status ".



Here is a marvelous explantion about git submodule:
https://stackoverflow.com/questions/20655073/how-to-see-which-commit-a-git-submodule-points-at/54238999
