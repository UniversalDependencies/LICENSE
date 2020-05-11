# LICENSE
License text for each and every element of the latest UD release.

## How to create a joint license for a new release of Universal Dependencies.

The Lindat-maintained licenses are stored on Github at https://github.com/ufal/clarin-dspace/, branch "clarin-dev" (at least that is where Ondřej directed his pull request; there may be other steps needed to make the new license actually appear on the web). The path is dspace-xmlui/src/main/webapp/themes/UFAL/lib/html/ (https://github.com/ufal/clarin-dspace/tree/clarin-dev/dspace-xmlui/src/main/webapp/themes/UFAL/lib/html). The file-naming convention is "licence-UD-N.M.{xml|html}" where N.M is the UD release number. The XML file contains metadata about the license. The HTML file contains the actual license text. We should be able to generate these two files directly from our metadata, then submit a pull request to the clarin-dspace repository.

LICENSE/generate_license_for_lindat.pl --release 2.6 --date 2020/05/15 $(cat released_treebanks.txt)
