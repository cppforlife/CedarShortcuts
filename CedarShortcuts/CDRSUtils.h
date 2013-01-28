#import <Foundation/Foundation.h>

double CDRSTime(void);

#define CDRSTimeLog(marker) \
    for (double t1 = CDRSTime(); t1 != 0; NSLog(@"%@ took %f sec.", marker, CDRSTime() - t1), t1 = 0)

#define F(f, ...) [NSString stringWithFormat:f, ##__VA_ARGS__]
