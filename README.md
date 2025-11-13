# LICENSE
License text for each and every element of the latest UD release.

## How to create a joint license for a new release of Universal Dependencies.

The Lindat-maintained licenses are stored on GitHub at https://github.com/ufal/dspace-angular/, branch "clarin-v7".
The path is src/static-files/ (https://github.com/ufal/dspace-angular/tree/clarin-v7/src/static-files).
The file-naming convention is "license-UD-N.M.html" where N.M is the UD release number (note: older versions were
spelled "licence" instead of "license"). We should be able to generate the HTML file directly from our metadata,
then submit a pull request to the repository.

```
# Start in the parent folder of all UD repo clones.
RELDATE=2025/11/15
RELEASE=2.17
PREVIOUS=2.16
LICENSE/generate_license_for_lindat.pl --release ${RELEASE} --date ${RELDATE} $(cat released_treebanks.txt)
cd LICENSE
git add license-ud-${RELEASE}.html
git commit -a -m "Generated license for UD ${RELEASE}."
git push
cd ..

(git clone git@github.com:ufal/dspace-angular.git)

cd dspace-angular
git checkout -b ud${RELEASE}_license
cd src/static-files
cp license-ud-${PREVIOUS}.html license-ud-${RELEASE}.html
git add license-ud-${RELEASE}.*
git commit -m 'Copied previous UD license.'
cp ../../../LICENSE/license-ud-${RELEASE}.* .
git commit -a -m 'Changes for the upcoming UD release.'
git push --set-upstream origin ud${RELEASE}_license
cd ../../..
```

Create a pull request for 'ud2.17_license' on GitHub by visiting:
https://github.com/ufal/dspace-angular/pull/new/ud2.17_license

Warning: If we visit the above URL, GitHub may offer a different repository and branch as the default target!
Change target repository to "ufal/dspace-angular".
Change target branch to "clarin-v7".
https://github.com/ufal/dspace-angular/compare/clarin-v7...ufal:dspace-angular:ud2.17_license?expand=1

Request review of the pull request by @kosarko.
