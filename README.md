# LICENSE
License text for each and every element of the latest UD release.

## How to create a joint license for a new release of Universal Dependencies.

The Lindat-maintained licenses are stored on Github at https://github.com/ufal/clarin-dspace/, branch "clarin-dev" (at least that is where Ondřej directed his pull request; there may be other steps needed to make the new license actually appear on the web). The path is dspace-xmlui/src/main/webapp/themes/UFAL/lib/html/ (https://github.com/ufal/clarin-dspace/tree/clarin-dev/dspace-xmlui/src/main/webapp/themes/UFAL/lib/html). The file-naming convention is "licence-UD-N.M.{xml|html}" where N.M is the UD release number. The XML file contains metadata about the license. The HTML file contains the actual license text. We should be able to generate these two files directly from our metadata, then submit a pull request to the clarin-dspace repository.

```
RELDATE=2023/11/15
RELEASE=2.13
PREVIOUS=2.12
LICENSE/generate_license_for_lindat.pl --release ${RELEASE} --date ${RELDATE} $(cat released_treebanks.txt)
cd LICENSE
git add license-ud-${RELEASE}.*
git commit -a -m "Generated license for UD ${RELEASE}."
git push
cd ..

(git clone git@github.com:ufal/clarin-dspace.git)

cd clarin-dspace
git checkout -b ud${RELEASE}_license
cd dspace-xmlui/src/main/webapp/themes/UFAL/lib/html
cp license-ud-${PREVIOUS}.xml license-ud-${RELEASE}.xml
cp license-ud-${PREVIOUS}.html license-ud-${RELEASE}.html
git add license-ud-${RELEASE}.*
git commit -m 'Copied previous UD license.'
cp ../../../../../../../../../LICENSE/license-ud-${RELEASE}.* .
git commit -a -m 'Changes for the upcoming UD release.'
git push --set-upstream origin ud${RELEASE}_license
cd ../../../../../../../../..
```

Create a pull request for 'ud2.13_license' on GitHub by visiting:
https://github.com/ufal/clarin-dspace/pull/new/ud2.13_license

Warning: If we visit the above URL, Github will offer a different repository and branch as the default target!
Change target repository to "ufal/clarin-dspace".
Change target branch to "clarin-dev".
Request review of the pull request by @kosarko.
