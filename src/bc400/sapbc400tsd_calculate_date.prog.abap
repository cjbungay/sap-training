REPORT sapbc400tss_calculate_date.

PARAMETERS: pa_dat1 LIKE sy-datum,
            pa_days TYPE i.

DATA dat2 LIKE sy-datum.


dat2 = pa_dat1 + pa_days.

SKIP 2.
WRITE:    pa_dat1,
          '  +',
      (5) pa_days,
          text-001.
SKIP 1.
WRITE: text-002.

WRITE: 40 dat2.
