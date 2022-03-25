/*
 * Extension for timewarrior for calculate of total time include space
 * between tasks if space time less than ALLOWED_SPACE.
 */

#define _GNU_SOURCE
#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
#include <cjson/cJSON.h>
#include <stdbool.h>
#include <time.h>

#define BUF_SIZE (1024*1024)
#define ISO_UTC "%Y%m%dT%H%M%SZ"
#define ALLOWED_SPACE (60*60)                    /* one hour in seconds */

// TODO improve macros for work with only one argument "format"
#ifdef DEBUG
#define PRINTF(format, ...) printf(format, __VA_ARGS__)
#else
#define PRINTF(format, ...)
#endif

int main()
{
	int rc = EXIT_SUCCESS;
    char raw[BUF_SIZE];
    char c[1];
    size_t nr = 0, nw = 0, nr_json = 0;        /* numer read (or write) */
    size_t start_of_json = 0;
    cJSON *buf_json = NULL;
    cJSON *items = NULL;
    cJSON *item = NULL;
    _Bool is_json_data = false;
    _Bool is_eol = false;
    struct tm tm_start, tm_end;
    time_t t_start, t_end, t_total = 0;
    time_t h, m, s;                            /* hours minutes seconds */

    while (read(0, raw + nr, sizeof(char))) {
        if (is_json_data)
            nr_json++;
        if (*(raw + nr) == '\n') {
            if (is_eol)
                is_json_data = true;
            is_eol = true;
        } else {
            is_eol = false;
        }
        nr++;
    }
    start_of_json = nr - nr_json;
    PRINTF("read(): %ld\n", nr);
    PRINTF("is_json_data: %d\n", is_json_data);
    PRINTF("nr_json: %ld\n", nr_json);
    PRINTF("start_of_json: %ld\n", start_of_json);
    if (BUF_SIZE < nr)
        fprintf(stderr, "ERROR: Size of buffer is low than size of data\n");
#ifdef DEBUG
    nw = write(1, raw+start_of_json, nr);
    PRINTF("write(): %ld\n", nw);
#endif
    buf_json = cJSON_Parse(raw + start_of_json);
	if (buf_json == NULL) {
#ifdef DEBUG
		const char *error_ptr = cJSON_GetErrorPtr();
		if (error_ptr != NULL)
			fprintf(stderr, "Error before: %s\n", error_ptr);
#endif
		rc = EXIT_FAILURE;
		goto end;
	}
#ifdef DEBUG 
    int count = cJSON_GetArraySize(buf_json);
    PRINTF("count: %d\n", count);
#endif
    cJSON_ArrayForEach(item, buf_json)
    {
        if (cJSON_IsObject(item)) {
            cJSON *start = cJSON_GetObjectItemCaseSensitive(item, "start");
            cJSON *end = cJSON_GetObjectItemCaseSensitive(item, "end");
            if (cJSON_IsString(start)
                    && strptime(start->valuestring, ISO_UTC, &tm_start))
            {
                t_start = mktime(&tm_start);
                /* If space between end of previous piece and start of
                 * next is low than ALLOWED_SPACE adding it to total
                 * time too */
                if ((t_start - t_end) < ALLOWED_SPACE) {
                    t_total += t_start - t_end;
                    PRINTF("added space between\n", NULL);
                    PRINTF("t_total: %ldmin\n", t_total/60);
                }
                if (cJSON_IsString(end)
                        && strptime(end->valuestring, ISO_UTC, &tm_end))
                {
                    PRINTF("from %s to %s\n", start->valuestring,
                            end->valuestring);
                    t_end = mktime(&tm_end);
                } else {
                    PRINTF("from %s to %s\n", start->valuestring, "now");
                    t_end = time(NULL);
                    /* Correcting for timezone offset */
                    t_end += -7*60*60; // TODO use real value of timezone
                }
            }
            t_total += t_end - t_start;
            PRINTF("t_start: %ld\n", t_start);
            PRINTF("t_end: %ld\n", t_end);
            PRINTF("t_total: %ldmin\n", t_total/60);
        } else {
            fprintf(stderr, "getdate_err: %d\n", getdate_err);
        }
    }
    h = t_total / 3600;
    m = (t_total - h*3600) / 60;
    s = (t_total - h*3600 - m*60);
#ifdef DEBUG
    printf("---\nt_total: %ldsec\n", t_total);
    printf("%ldh%ldmin%ldsec\n", h, m, s);
#endif
    if (h > 0)
        printf("%ldh%ldmin", h, m);
    else
        printf("%ldmin", m);
end:
	cJSON_Delete(buf_json);
	return rc;
}
