"""
DevIntel Scheduler Jobs - Automated crawl of data sources.

Daily crawl of P1 data sources at 3:00AM AEST.
Weekly crawl of P2 sources, monthly crawl of P3 sources.
"""

import traceback
from datetime import datetime


def scheduled_devintel_crawl():
    """
    Daily crawl of active data sources.

    Crawl logic:
    - P1 sources: crawled daily
    - P2 sources: crawled on Mondays (weekly)
    - P3 sources: crawled on 1st of month (monthly)
    """
    now = datetime.now()
    day_of_week = now.weekday()  # 0=Monday
    day_of_month = now.day

    print(f"[DevIntel] Scheduled crawl started at {now.strftime('%Y-%m-%d %H:%M:%S')}")

    try:
        from devintel.crawler import crawl_all_sources

        # Always crawl P1 (daily)
        print("[DevIntel] Crawling P1 sources (daily)...")
        p1_result = crawl_all_sources(priority_filter="P1")
        print(f"[DevIntel] P1 done: {p1_result.get('total_new', 0)} new, "
              f"{p1_result.get('total_chunks', 0)} chunks")

        # Crawl P2 on Mondays (weekly)
        if day_of_week == 0:
            print("[DevIntel] Crawling P2 sources (weekly - Monday)...")
            p2_result = crawl_all_sources(priority_filter="P2")
            print(f"[DevIntel] P2 done: {p2_result.get('total_new', 0)} new, "
                  f"{p2_result.get('total_chunks', 0)} chunks")

        # Crawl P3 on 1st of month
        if day_of_month == 1:
            print("[DevIntel] Crawling P3 sources (monthly - 1st)...")
            p3_result = crawl_all_sources(priority_filter="P3")
            print(f"[DevIntel] P3 done: {p3_result.get('total_new', 0)} new, "
                  f"{p3_result.get('total_chunks', 0)} chunks")

        print(f"[DevIntel] Scheduled crawl completed at {datetime.now().strftime('%H:%M:%S')}")

    except Exception as e:
        print(f"[DevIntel] Scheduled crawl FAILED: {e}")
        traceback.print_exc()

        # Log failure
        try:
            from database import execute_query
            execute_query("""
                INSERT INTO devintel_crawl_logs
                (source_name, crawl_type, status, error_message, finished_at)
                VALUES (%s, %s, %s, %s, NOW())
            """, ("scheduler", "scheduled", "failed", str(e)))
        except Exception:
            pass
