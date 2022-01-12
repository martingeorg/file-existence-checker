#!/bin/bash

jobName=job-"$1".sh

(
cat <<-JOBFILECONTENT
#!/bin/bash

# set folder1 path
folder1="./"

# set folder2 path
folder2="./"

./find-missing-files-in-second-folder.sh \$folder1 \$folder2
JOBFILECONTENT
) > ./$jobName

chmod u+x ./$jobName
