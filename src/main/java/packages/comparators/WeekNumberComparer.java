
package packages.comparators;

import java.util.Comparator;
import packages.tables.CourseWeek;

//https://stackoverflow.com/questions/5805602/how-to-sort-list-of-objects-by-some-property

public class WeekNumberComparer implements Comparator<CourseWeek> {
    
  @Override
  public int compare(CourseWeek x, CourseWeek y) {

    int startComparison = compare(x.getWeekNumber(), y.getWeekNumber());
    
    return startComparison;
  }

  // I don't know why this isn't in Long...
  private static int compare(long a, long b) {
    return a < b ? -1
         : a > b ? 1
         : 0;
  }
}