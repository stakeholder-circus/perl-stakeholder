FROM alpine:3.20
LABEL org.opencontainers.image.title="perl-stakeholder"
LABEL org.opencontainers.image.description="Scaffold-only placeholder container for perl-stakeholder"
CMD ["sh", "-lc", "echo 'perl-stakeholder scaffold-only baseline';"]
