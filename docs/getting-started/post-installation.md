# Post-Installation Setup

After deploying OpenTalk with Docker, there are several important steps to complete the setup.

## Setting Up Keycloak Authentication

OpenTalk uses Keycloak for user authentication and management. After initial deployment, you'll need to:

1. **Access the Keycloak Admin Console**
   - URL: `https://keycloak.yourdomain.com/admin/`
   - Login with the admin credentials set in your `.env` file:
     - Username: `admin`
     - Password: The value of `KEYCLOAK_ADMIN_PASSWORD`

2. **Select the OpenTalk Realm**
   - After login, you should see the "opentalk" realm in the dropdown in the upper left corner
   - Select this realm to manage users for OpenTalk

3. **Create a New User**
   - Navigate to "Users" in the left menu
   - Click "Add user"
   - Fill in at least the following fields:
     - Username
     - Email
     - First and Last Name
   - Toggle "Email Verified" to On
   - Click "Create"

4. **Set Password for the New User**
   - After creating the user, go to the "Credentials" tab
   - Set a password and turn off "Temporary" if you don't want the user to reset it on first login
   - Click "Set Password"

5. **Assign Roles to the User**
   - Go to the "Role Mappings" tab
   - Under "Available Roles", select "default-roles-opentalk"
   - Click "Add selected"

## Testing Your OpenTalk Installation

1. **Access the OpenTalk Web Interface**
   - Open your browser and navigate to: `https://yourdomain.com`
   - You should see the OpenTalk login screen

2. **Login with Your New User**
   - Enter the credentials for the user you created in Keycloak
   - After successful login, you'll be taken to the OpenTalk dashboard

3. **Create a Meeting**
   - Click "New Meeting" from the dashboard
   - Configure your meeting settings
   - Start the meeting to test audio and video functionality

## Troubleshooting Common Issues

### Authentication Problems

If users cannot log in:
- Verify Keycloak is properly connected to OpenTalk
- Check the Controller configuration for correct Keycloak settings
- Examine the Keycloak logs for authentication errors

### Media Connection Issues

If audio/video doesn't work:
- Ensure LiveKit is properly configured
- Verify that UDP ports (7880-7882) are open
- Check browser console for WebRTC connection errors

### SSL Certificate Issues

If you encounter certificate warnings:
- Verify that your SSL certificates are correctly configured in Traefik
- Ensure all domain names have valid certificates
- Check that the certificates cover all required subdomains

## Maintenance Tasks

### Backing Up Your Configuration

It's important to regularly back up your OpenTalk configuration:

```bash
# Back up the .env file
cp .env .env.backup-$(date +%Y%m%d)

# Back up configuration files
tar -czf opentalk-config-backup-$(date +%Y%m%d).tar.gz config/
```

### Backup Considerations

Consider regular backups of:
- PostgreSQL database
- MinIO data
- Keycloak data

A simple database backup command:

```bash
docker compose exec postgres pg_dump -U opentalk opentalk > opentalk-db-backup-$(date +%Y%m%d).sql
```