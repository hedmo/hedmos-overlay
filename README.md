Hedmos-Overlay 

An overlay to have some  Eye candy on Gentoo and some extras 

To use this overlay, run

emerge -n app-eselect/eselect-repository dev-vcs/git
eselect repository add hedmos-overlay git https://github.com/hedmo/hedmos-overlay.git
emaint sync -r hedmos-overlay
Please ensure that the repository stays in sync. You may use these commands:

emaint sync -r hedmos-overlay # just this repository
# OR
emaint sync -A               # all repositories
# OR
emaint sync -a               # all auto-sync repositories
To sync automatically with your usual portage sync, ensure auto-sync is enabled for this repository. Auto-sync defaults to true, if in doubt, check man portage.

After the repository is synced, unmask/mask as appropriate.
