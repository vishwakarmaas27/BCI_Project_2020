Erroneous Eye blinks detection issue using TG_GetValue() - TG_DATA_BLINK_STRENGTH data request.

In-order to detect Eye blinks, using TG_GetValue(), TG_DATA_BLINK_STRENGTH = 37 has to be set and in this case, the subject needs to be very steady and should not move their head quite often and shouldn't laugh a lot, in these cases there are chances that erroneous eye blinks might be detected, because eye blinks are detected via muscle movements and laughter causes muscle movements of those regions where eye muscles are present.

Permanent solution is to read eye blinks by taking RAW brainwaves as input and sampling it to find out the eye blinks.
