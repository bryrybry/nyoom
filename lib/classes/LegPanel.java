public class LegPanel {
    private String fromLocation;
    private String mode;
    private String toLocation;
    private int duration;
    private String route;
    private int startIndex;
    private int endIndex;

    public LegPanel(String fromLocation, String mode, String toLocation, int duration, String route, int startIndex, int endIndex) {
        this.fromLocation = fromLocation;
        this.mode = mode;
        this.toLocation = toLocation;
        this.duration = duration;
        this.route = route;
        this.startIndex = startIndex;
        this.endIndex = endIndex;
    }
    public String getFromLocation() { return fromLocation; }
    public String getMode() { return mode; }
    public String getToLocation() { return toLocation; }
    public int getDuration() { return duration; }
    public String getRoute() { return route; }
    public int getStartIndex() { return startIndex; }
    public int getEndIndex() { return endIndex; }
}
