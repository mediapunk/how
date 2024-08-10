title: Getting Mac Hardware Info


On some Mac systems, I was able to feed the output of `system_profiler SPHardwareDataType` directly into `yq` like this:

     system_profiler SPHardwareDataType | yq '.Hardware' | grep -E "(Name|Core|Chip|Memory)"
>     Model Name: Mac mini
>     Chip: Apple M1
>     Total Number of Cores: 8 (4 performance and 4 efficiency)
>     Memory: 8 GB

But this depends on the yq version, and can't tolerate a line with multiple colons, like this one that I got on a 2019 MacBook Air:

>     System Firmware Version: 2022.100.22.0.0 (iBridge: 21.16.5077.0.0,0)

So we'll use `sed` to rewrite the lines to have their values quoted and finagle some valid YAML:

    system_profiler SPHardwareDataType | sed -E "s/ *([^:]*): *(.*)/\1: '\2'/"
>     Hardware: ''
>
>     Hardware Overview: ''
>
>     Model Name: 'Mac mini'
>     Model Identifier: 'Macmini9,1'
>     Model Number: 'MGNR3LL/A'
>     Chip: 'Apple M1'
>     ...

Then using `grep` to search for specific words, I get

    system_profiler SPHardwareDataType | sed -E "s/ *([^:]*): *(.*)/\1: '\2'/" | grep -E "(Name|Identifier|Chip|Processor|Number of|Memory)"
>     Model Name: 'Mac mini'
>     Chip: 'Apple M1'
>     Total Number of Cores: '8 (4 performance and 4 efficiency)'
>     Memory: '8 GB'


Model Name: 'Mac mini'
Model Identifier: 'Macmini9,1'
Chip: 'Apple M1'
Total Number of Cores: '8 (4 performance and 4 efficiency)'
Memory: '8 GB'

Model Name: 'Mac mini'
Model Identifier: 'Macmini6,2'
Processor Name: 'Quad-Core Intel Core i7'
Processor Speed: '2.6 GHz'
Number of Processors: '1'
Total Number of Cores: '4'
Memory: '16 GB'


