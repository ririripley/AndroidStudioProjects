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