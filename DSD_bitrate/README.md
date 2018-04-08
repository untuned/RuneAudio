DSD Bitrate extractor
---

Extract bitrate from DSD files, *.dsf and *.dff
- Usage: `./dsdbitrate.sh </path/file>`

### DSD File Specifications
- [DSF File Format](http://dsd-guide.com/sites/default/files/white-papers/DSFFileFormatSpec_E.pdf)  
- [DSDIFF File Format](http://www.sonicstudio.com/pdf/dsd/DSDIFF_1.5_Spec.pdf)  

### Bitrate byte number
```
|----------------------------------------------------------|
|        |          |          |  DSF byte#  |  DFF byte#  |
|        |    dec   |    hex   |  5758 5960  |  6162 6364  |
|----------------------------------------------------------|
| DSD64  |  2822400 | 002b1100 |  1100 002b  |  2b00 0011  |
| DSD128 |  5644800 | 00562200 |  2200 0056  |  5600 0022  |
| DSD256 | 11289600 | 00AC4400 |  4400 00AC  |  AC00 0044  |
| DSD512 | 22579200 | 01588800 |  8800 0158  |  5801 0088  |
|----------------------------------------------------------|
```
